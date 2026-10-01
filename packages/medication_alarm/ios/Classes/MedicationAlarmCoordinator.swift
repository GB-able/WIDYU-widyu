import AlarmKit
import AppIntents
import BackgroundTasks
import CryptoKit
import Foundation
import SwiftUI
import UIKit
import UserNotifications

private enum AlarmBridgeError: LocalizedError {
    case invalid(String)
    var errorDescription: String? { if case let .invalid(message) = self { return message }; return nil }
}

/// One coordinator serializes work from all Flutter engines and App Intents.
/// No API tokens or proof photos are stored here.
@MainActor
final class MedicationAlarmCoordinator {
    static let shared = MedicationAlarmCoordinator()
    private var tail: Task<Void, Never>?
    private var storage: [String: Any]?
    private let center = UNUserNotificationCenter.current()
    private var updates: Task<Void, Never>?
    private var backgroundRegistered = false
    private static let refreshID = "com.widyu.medication.refresh"
    private static let watchdogID = "widyu.medication.watchdog"

    func registerBackground() {
        guard !backgroundRegistered else { return }
        backgroundRegistered = true
        if #unavailable(iOS 26.0) {
            MedicationAlarmPlayer.shared.onFire = { [weak self] id in self?.fired(id) }
            MedicationAlarmPlayer.shared.onStop = { [weak self] in self?.rearm() }
            MedicationAlarmPlayer.shared.onHeartbeat = { [weak self] in self?.watchdog(after: MedicationAlarmPlayer.watchdogDelay) }
            MedicationAlarmPlayer.shared.onIdle = { [weak self] in self?.center.removePendingNotificationRequests(withIdentifiers: [Self.watchdogID]) }
            rearm()
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.refreshID, using: .main) { task in
            Task { @MainActor in
                self.enqueue {
                    do {
                        var state = try self.load()
                        guard let plan = state["plan"] as? [String: Any], state["sessionId"] != nil else {
                            task.setTaskCompleted(success: true); return
                        }
                        state["groups"] = self.expand(plan, memberId: state["memberId"] as! String)
                        try self.save(state)
                        _ = try await self.reconcile()
                        self.scheduleRefresh()
                        task.setTaskCompleted(success: true)
                    } catch { self.scheduleRefresh(); task.setTaskCompleted(success: false) }
                }
            }
        }
    }
    private func scheduleRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.refreshID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 12 * 60 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    func enqueue(_ operation: @escaping @MainActor () async -> Void) {
        let previous = tail
        tail = Task { await previous?.value; await operation() }
    }
    private func load() throws -> [String: Any] {
        if let storage { return storage }
        let url = try fileURL()
        if FileManager.default.fileExists(atPath: url.path) {
            let value = try JSONSerialization.jsonObject(with: Data(contentsOf: url))
            guard let state = value as? [String: Any] else { throw AlarmBridgeError.invalid("INVALID_STORE") }
            storage = state
            return state
        }
        let state: [String: Any] = ["installationId": UUID().uuidString]
        try save(state)
        return state
    }
    private func fileURL() throws -> URL {
        let root = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return root.appendingPathComponent("widyu-medication-alarm.json")
    }
    private func save(_ state: [String: Any]) throws {
        let url = try fileURL()
        try JSONSerialization.data(withJSONObject: state, options: [.sortedKeys])
            .write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
        storage = state
    }
    private func requireSession(_ state: [String: Any], _ args: [String: Any]) throws {
        guard let session = args["sessionId"] as? String, !session.isEmpty,
              state["sessionId"] as? String == session else { throw AlarmBridgeError.invalid("STALE_SESSION") }
    }
    private func emit() { NotificationCenter.default.post(name: .medicationAlarmChanged, object: nil) }
    private func observe() {
        guard updates == nil else { return }
        if #available(iOS 26.0, *) {
            updates = Task {
                for await _ in AlarmManager.shared.alarmUpdates {
                    if UIApplication.shared.applicationState == .active { _ = try? self.activeGroup() }
                    self.emit()
                }
            }
        }
    }
    func capabilities() async -> [String: Any] {
        let settings = await center.notificationSettings()
        let notifications = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
        var authorized = notifications
        var mode = "scheduledNotification"
        if #available(iOS 26.0, *) { authorized = AlarmManager.shared.authorizationState == .authorized; mode = "alarmKit" }
        return ["platform": "ios", "mode": mode, "authorized": authorized,
                "notifications": notifications, "fullScreen": false,
                "timeZone": TimeZone.current.identifier, "osVersion": UIDevice.current.systemVersion]
    }
    func handle(_ method: String, args: [String: Any]) async throws -> Any? {
        observe()
        switch method {
        case "capabilities": return await capabilities()
        case "requestPermissions":
            guard UIApplication.shared.applicationState == .active else { throw AlarmBridgeError.invalid("FOREGROUND_REQUIRED") }
            if #available(iOS 26.0, *) { _ = try await AlarmManager.shared.requestAuthorization() }
            else { _ = try await center.requestAuthorization(options: [.alert, .sound, .badge]) }
            return await capabilities()
        case "openSettings":
            if let url = URL(string: UIApplication.openSettingsURLString) { await UIApplication.shared.open(url) }
            return nil
        case "activate":
            guard let member = args["memberId"] as? String, !member.isEmpty else { throw AlarmBridgeError.invalid("INVALID_MEMBER") }
            var state = try load()
            if state["memberId"] as? String != member || state["sessionId"] == nil {
                try await clear()
                state = try load()
                state["memberId"] = member; state["sessionId"] = UUID().uuidString; state["revision"] = -1
                try save(state)
            }
            return state
        case "state":
            var state = try load(); state["capabilities"] = await capabilities(); return state
        case "activeGroup": return try activeGroup()
        case "clearSession": try await clear(); return nil
        case "applyPlan":
            var state = try load(); try requireSession(state, args)
            guard let plan = args["plan"] as? [String: Any], plan["complete"] as? Bool == true,
                let revision = plan["revision"] as? Int,
                let groups = args["groups"] as? [[String: Any]],
                plan["memberId"] as? String == state["memberId"] as? String
            else { throw AlarmBridgeError.invalid("INVALID_SNAPSHOT") }
            guard plan["timeZone"] as? String == TimeZone.current.identifier else { throw AlarmBridgeError.invalid("TIMEZONE_CHANGED") }
            guard revision >= (state["revision"] as? Int ?? -1) else { throw AlarmBridgeError.invalid("STALE_REVISION") }
            let history = ((state["history"] as? [[String: Any]] ?? []) + (state["groups"] as? [[String: Any]] ?? []))
                .filter { (($0["scheduledAt"] as? NSNumber)?.doubleValue ?? 0) > Date().timeIntervalSince1970 * 1000 - 24 * 60 * 60 * 1000 }
            state["history"] = Array(Dictionary(history.map { ($0["groupId"] as! String, $0) }, uniquingKeysWith: { _, new in new }).values)
            state["revision"] = revision; state["plan"] = plan; state["groups"] = groups
            try save(state)
            scheduleRefresh()
            return try await reconcile()
        case "complete":
            var state = try load(); try requireSession(state, args)
            MedicationAlarmPlayer.shared.stop()
            let ids = args["occurrenceIds"] as? [String] ?? []
            let completed = Set(state["completed"] as? [String] ?? []).union(ids)
            state["completed"] = Array(completed.sorted().suffix(4096)); try save(state)
            return try await reconcile()
        case "stop":
            MedicationAlarmPlayer.shared.stop()
            if let groupId = args["groupId"] as? String {
                let id = alarmID(groupId)
                if #available(iOS 26.0, *) { try? AlarmManager.shared.stop(id: id) }
                center.removeDeliveredNotifications(withIdentifiers: [legacyID(id)])
            }
            emit()
            return nil
        case "pendingLaunch": return (try load()["launches"] as? [[String: Any]])?.first ?? [:]
        case "acknowledgeLaunch":
            var state = try load()
            state["launches"] = (state["launches"] as? [[String: Any]] ?? []).filter { $0["eventId"] as? String != args["eventId"] as? String }
            try save(state); return nil
        default: throw AlarmBridgeError.invalid("UNKNOWN_METHOD")
        }
    }
    private func clear() async throws {
        let old = try load()
        try save(["installationId": old["installationId"]!])
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.refreshID)
        MedicationAlarmPlayer.shared.disarm()
        if #available(iOS 26.0, *) {
            for alarm in (try? AlarmManager.shared.alarms) ?? [] { try? AlarmManager.shared.cancel(id: alarm.id) }
        }
        let pending = await center.pendingNotificationRequests()
        center.removePendingNotificationRequests(withIdentifiers: pending.map(\.identifier).filter { $0.hasPrefix("widyu.medication.") })
        let delivered = await center.deliveredNotifications()
        center.removeDeliveredNotifications(withIdentifiers: delivered.map { $0.request.identifier }.filter { $0.hasPrefix("widyu.medication.") })
        emit()
    }

    private func reconcile() async throws -> [String: Any] {
        var state = try load()
        let caps = await capabilities()
        let authorized = caps["authorized"] as? Bool == true
        let now = Date().timeIntervalSince1970 * 1000
        let completed = Set(state["completed"] as? [String] ?? [])
        let plan = state["plan"] as? [String: Any] ?? [:]
        let excluded = completed.union(plan["excludedOccurrenceIds"] as? [String] ?? [])
        let all = (state["groups"] as? [[String: Any]] ?? []).compactMap { group -> [String: Any]? in
            guard let at = group["scheduledAt"] as? NSNumber, at.doubleValue > now else { return nil }
            let remaining = (group["occurrences"] as? [[String: Any]] ?? []).filter { !excluded.contains($0["occurrenceId"] as? String ?? "") }
            guard !remaining.isEmpty else { return nil }
            var updated = group; updated["occurrences"] = remaining; return updated
        }.sorted { ($0["scheduledAt"] as! NSNumber).doubleValue < ($1["scheduledAt"] as! NSNumber).doubleValue }
        let pending = await center.pendingNotificationRequests()
        var capacity = 48
        if #unavailable(iOS 26.0) {
            capacity = max(0, min(48, 64 - pending.filter { !$0.identifier.hasPrefix("widyu.medication.") }.count))
            let categories = await center.notificationCategories()
            let verify = UNNotificationAction(identifier: "MEDICATION_VERIFY", title: "인증하기", options: [.foreground, .authenticationRequired])
            let stop = UNNotificationAction(identifier: "MEDICATION_STOP", title: "중단", options: [.destructive])
            center.setNotificationCategories(categories.filter { $0.identifier != "WIDYU_MEDICATION" }.union([UNNotificationCategory(identifier: "WIDYU_MEDICATION",
                actions: [verify, stop], intentIdentifiers: [], options: [])]))
        }
        let desired = authorized ? Array(all.prefix(capacity)) : []
        let desiredIDs = Set(desired.map { alarmID($0["groupId"] as! String) })
        var existingIDs = Set<UUID>()
        var ringing = Set<UUID>()
        if #available(iOS 26.0, *) {
            let alarms = (try? AlarmManager.shared.alarms) ?? []
            existingIDs = Set(alarms.map(\.id))
            ringing = Set(alarms.filter { $0.state == .alerting }.map(\.id))
        }
        else { existingIDs = Set(pending.compactMap { UUID(uuidString: String($0.identifier.dropFirst("widyu.medication.".count))) }) }
        let previous = state["scheduled"] as? [[String: Any]] ?? []
        let previousByID = Dictionary(uniqueKeysWithValues: previous.map { (alarmID($0["groupId"] as! String), $0) })
        let history = (state["history"] as? [[String: Any]] ?? []) + (state["groups"] as? [[String: Any]] ?? [])
        let rules = plan["schedules"] as? [[String: Any]] ?? []
        let validRinging = Set(history.filter { group in
            (group["occurrences"] as? [[String: Any]] ?? []).contains { occurrence in
                !excluded.contains(occurrence["occurrenceId"] as? String ?? "") && rules.contains { rule in
                    rule["enabled"] as? Bool == true && (rule["scheduleId"] as? Int) == (occurrence["scheduleId"] as? Int) &&
                        self.localTime(occurrence["scheduledAt"] as? NSNumber) == rule["alarmTime"] as? String
                }
            }
        }.map { alarmID($0["groupId"] as! String) }).intersection(ringing)
        for id in existingIDs.subtracting(desiredIDs).subtracting(authorized ? validRinging : []) { try cancel(id) }
        // Journal desired IDs before OS calls. Reconciliation queries the OS on retry.
        state["applying"] = desired; try save(state)
        var actual = [[String: Any]]()
        var failures = [[String: Any]]()
        var coverageEnd: Double?
        for group in desired {
            let id = alarmID(group["groupId"] as! String)
            do {
                if !existingIDs.contains(id) || !equal(previousByID[id], group) {
                    if existingIDs.contains(id) { try cancel(id) }
                    try await schedule(group, id: id)
                }
                actual.append(group)
                if failures.isEmpty { coverageEnd = (group["scheduledAt"] as! NSNumber).doubleValue }
            } catch {
                failures.append(["groupId": group["groupId"]!, "code": String(describing: error)])
            }
        }
        let hasSchedules = (plan["schedules"] as? [[String: Any]] ?? []).contains { $0["enabled"] as? Bool == true }
        let through: Double? = hasSchedules ? coverageEnd : nil
        let needsRefill = hasSchedules && (through ?? now) - now < 3 * 24 * 60 * 60 * 1000
        let status: [String: Any] = [
            "capabilities": caps, "desiredRevision": state["revision"] ?? -1,
            "appliedRevision": authorized && failures.isEmpty ? (state["revision"] ?? -1) : NSNull(),
            "continuous": false, "scheduledThrough": through.map { $0 as Any } ?? NSNull(),
            "scheduledCount": actual.count, "failures": failures,
            "timeZone": TimeZone.current.identifier, "reportedAt": now,
            "status": !authorized ? "permissionRequired" : !failures.isEmpty ? "partialFailure" : needsRefill ? "refillRequired" : "scheduled"
        ]
        state["scheduled"] = actual; state["status"] = status; state.removeValue(forKey: "applying")
        try save(state)
        if #unavailable(iOS 26.0) { armPlayer(from: actual) }
        emit()
        return status
    }
    private func equal(_ left: [String: Any]?, _ right: [String: Any]) -> Bool {
        guard let left else { return false }
        return (try? JSONSerialization.data(withJSONObject: left, options: .sortedKeys)) ==
               (try? JSONSerialization.data(withJSONObject: right, options: .sortedKeys))
    }
    private func cancel(_ id: UUID) throws {
        if #available(iOS 26.0, *) { try AlarmManager.shared.cancel(id: id) }
        center.removePendingNotificationRequests(withIdentifiers: [legacyID(id)])
        center.removeDeliveredNotifications(withIdentifiers: [legacyID(id)])
    }
    private func schedule(_ group: [String: Any], id: UUID) async throws {
        let at = Date(timeIntervalSince1970: (group["scheduledAt"] as! NSNumber).doubleValue / 1000)
        let title = title(group)
        if #available(iOS 26.0, *) {
            let button = AlarmButton(text: "인증하러 가기", textColor: .white, systemImageName: "camera.fill")
            let alert: AlarmPresentation.Alert
            if #available(iOS 26.1, *) {
                alert = AlarmPresentation.Alert(title: LocalizedStringResource(stringLiteral: title),
                    secondaryButton: button, secondaryButtonBehavior: .custom)
            } else {
                alert = AlarmPresentation.Alert(title: LocalizedStringResource(stringLiteral: title),
                    stopButton: AlarmButton(text: "중단", textColor: .white, systemImageName: "stop.fill"),
                    secondaryButton: button, secondaryButtonBehavior: .custom)
            }
            let attributes = AlarmAttributes<MedicationAlarmMetadata>(presentation: AlarmPresentation(alert: alert),
                metadata: MedicationAlarmMetadata(), tintColor: Color(red: 1, green: 0.47, blue: 0.06))
            let configuration = AlarmManager.AlarmConfiguration<MedicationAlarmMetadata>.alarm(
                schedule: .fixed(at), attributes: attributes,
                secondaryIntent: OpenMedicationIntent(alarmID: id.uuidString), sound: .default)
            _ = try await AlarmManager.shared.schedule(id: id, configuration: configuration)
        } else {
            let content = UNMutableNotificationContent()
            content.title = title; content.body = "눌러서 복용 사진을 인증해 주세요."
            content.sound = installedSound(); content.categoryIdentifier = "WIDYU_MEDICATION"
            content.interruptionLevel = .timeSensitive
            content.userInfo = ["widyuMedication": id.uuidString]
            var calendar = Calendar(identifier: .gregorian); calendar.timeZone = .current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: at)
            components.timeZone = .current
            try await center.add(UNNotificationRequest(identifier: legacyID(id), content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)))
        }
    }
    func open(id: String) throws {
        guard let uuid = UUID(uuidString: id) else { return }
        try recordLaunch(uuid)
        MedicationAlarmPlayer.shared.stop()
        if #available(iOS 26.0, *) { try? AlarmManager.shared.stop(id: uuid) }
        emit()
    }
    private func group(for id: UUID, in state: [String: Any]) -> [String: Any]? {
        ((state["groups"] as? [[String: Any]] ?? []) + (state["history"] as? [[String: Any]] ?? []))
            .first(where: { alarmID($0["groupId"] as! String) == id })
    }
    private func activeGroup() throws -> [String: Any] {
        let state = try load()
        if let id = MedicationAlarmPlayer.shared.ringingID,
           let group = group(for: id, in: state),
           group["memberId"] as? String == state["memberId"] as? String { return group }
        if #available(iOS 26.0, *) {
            guard let id = ((try? AlarmManager.shared.alarms) ?? []).first(where: { $0.state == .alerting })?.id,
                  let group = group(for: id, in: state),
                  group["memberId"] as? String == state["memberId"] as? String else { return [:] }
            if UIApplication.shared.applicationState == .active {
                MedicationAlarmPlayer.shared.startForeground(id: id)
                do { try AlarmManager.shared.stop(id: id) }
                catch { MedicationAlarmPlayer.shared.stop() }
            }
            return group
        }
        return [:]
    }
    private func recordLaunch(_ id: UUID) throws {
        var state = try load()
        // groups are retained after firing; callbacks must not depend on a live Dart listener.
        guard let group = group(for: id, in: state), group["memberId"] as? String == state["memberId"] as? String else { return }
        var launches = state["launches"] as? [[String: Any]] ?? []
        if !launches.contains(where: { ($0["group"] as? [String: Any])?["groupId"] as? String == group["groupId"] as? String }) {
            launches.append(["eventId": UUID().uuidString, "memberId": state["memberId"]!, "group": group])
            state["launches"] = Array(launches.suffix(8)); try save(state)
        }
    }
    private func title(_ group: [String: Any]) -> String {
        let count = (group["occurrences"] as? [[String: Any]] ?? []).reduce(0.0) { $0 + ($1["doseCount"] as! NSNumber).doubleValue }
        return "\(count.formatted(.number.precision(.fractionLength(0...2))))정 복용하실 시간이에요!"
    }
    func rearm() {
        guard #unavailable(iOS 26.0) else { return }
        armPlayer(from: (try? load())?["scheduled"] as? [[String: Any]] ?? [])
    }
    private func armPlayer(from groups: [[String: Any]]) {
        let now = Date()
        let next = groups.compactMap { group -> (id: UUID, at: Date)? in
            let at = Date(timeIntervalSince1970: (group["scheduledAt"] as! NSNumber).doubleValue / 1000)
            let id = alarmID(group["groupId"] as! String)
            return at > now && id != MedicationAlarmPlayer.shared.lastFired ? (id, at) : nil
        }.min { $0.at < $1.at }
        MedicationAlarmPlayer.shared.arm(next: next)
    }
    func resumed() throws {
        if MedicationAlarmPlayer.shared.ringingID != nil { emit() } else { rearm() }
    }
    private func fired(_ id: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: [legacyID(id)])
        center.removeDeliveredNotifications(withIdentifiers: [legacyID(id)])
        guard let state = try? load(), let group = group(for: id, in: state) else { return }
        if UIApplication.shared.applicationState != .active {
            let content = UNMutableNotificationContent()
            content.title = title(group); content.body = "눌러서 복용 사진을 인증해 주세요."
            content.categoryIdentifier = "WIDYU_MEDICATION"; content.userInfo = ["widyuMedication": id.uuidString]
            content.interruptionLevel = .timeSensitive
            center.add(UNNotificationRequest(identifier: legacyID(id), content: content, trigger: nil)) { _ in }
            try? recordLaunch(id)
        }
        emit()
    }
    private func watchdog(after delay: TimeInterval?, done: @escaping @Sendable () -> Void = {}) {
        let content = UNMutableNotificationContent()
        content.title = "위듀 앱을 다시 켜주세요"
        content.body = "앱이 꺼지면 알람 기능이 정상적으로 동작하지 않아요."
        content.sound = .default; content.interruptionLevel = .timeSensitive
        let trigger = delay.map { UNTimeIntervalNotificationTrigger(timeInterval: $0, repeats: false) }
        center.add(UNNotificationRequest(identifier: delay == nil ? "\(Self.watchdogID).terminated" : Self.watchdogID, content: content, trigger: trigger)) { _ in done() }
    }
    private var terminating = false
    func terminated() {
        guard !terminating, MedicationAlarmPlayer.shared.engaged else { return }
        terminating = true
        MedicationAlarmPlayer.shared.log("terminated")
        center.removePendingNotificationRequests(withIdentifiers: [Self.watchdogID])
        let sent = DispatchSemaphore(value: 0)
        watchdog(after: nil) { sent.signal() }
        _ = sent.wait(timeout: .now() + 2)
    }
    func stopRinging(id: String) {
        MedicationAlarmPlayer.shared.stop()
        guard let uuid = UUID(uuidString: id) else { return }
        if #available(iOS 26.0, *) { try? AlarmManager.shared.stop(id: uuid) }
        center.removeDeliveredNotifications(withIdentifiers: [legacyID(uuid)])
        guard var state = try? load() else { return }
        state["launches"] = (state["launches"] as? [[String: Any]] ?? []).filter {
            (($0["group"] as? [String: Any])?["groupId"] as? String).map(alarmID) != uuid
        }
        try? save(state)
    }
    private func legacyID(_ id: UUID) -> String { "widyu.medication.\(id.uuidString)" }
    private static let soundFile = "medication_alarm.caf"
    private func installedSound() -> UNNotificationSound {
        guard let source = Bundle(for: MedicationAlarmCoordinator.self).url(forResource: "medication_alarm", withExtension: "caf"),
              let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return .default }
        let sounds = library.appendingPathComponent("Sounds", isDirectory: true)
        let target = sounds.appendingPathComponent(Self.soundFile)
        if !FileManager.default.fileExists(atPath: target.path) {
            try? FileManager.default.createDirectory(at: sounds, withIntermediateDirectories: true)
            guard (try? FileManager.default.copyItem(at: source, to: target)) != nil else { return .default }
        }
        return UNNotificationSound(named: UNNotificationSoundName(Self.soundFile))
    }
    private func localTime(_ millis: NSNumber?) -> String? {
        guard let millis else { return nil }
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(timeIntervalSince1970: millis.doubleValue / 1000))
        return String(format: "%02d:%02d", components.hour!, components.minute!)
    }
    private func expand(_ plan: [String: Any], memberId: String) -> [[String: Any]] {
        var calendar = Calendar(identifier: .gregorian); calendar.timeZone = .current
        let now = Date()
        let excluded = Set(plan["excludedOccurrenceIds"] as? [String] ?? [])
        var grouped = [Int64: [[String: Any]]]()
        for day in 0..<30 {
            let date = calendar.date(byAdding: .day, value: day, to: calendar.startOfDay(for: now))!
            for rule in plan["schedules"] as? [[String: Any]] ?? [] where rule["enabled"] as? Bool == true {
                let time = (rule["alarmTime"] as! String).split(separator: ":").compactMap { Int($0) }
                var components = calendar.dateComponents([.year, .month, .day], from: date)
                components.hour = time[0]; components.minute = time[1]
                guard let at = calendar.date(from: components), at > now else { continue }
                let localDate = String(format: "%04d-%02d-%02d", components.year!, components.month!, components.day!)
                let occurrenceID = "\(rule["scheduleId"]!):\(localDate)"
                if excluded.contains(occurrenceID) { continue }
                let end = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: date)!
                let millis = Int64(at.timeIntervalSince1970 * 1000)
                grouped[millis, default: []].append([
                    "occurrenceId": occurrenceID, "scheduleId": rule["scheduleId"]!, "localDate": localDate,
                    "scheduledAt": millis, "doseCount": rule["doseCount"]!, "timeZone": TimeZone.current.identifier,
                    "opensAt": max(date, at.addingTimeInterval(-1800)).timeIntervalSince1970 * 1000,
                    "closesAt": min(end, at.addingTimeInterval(1800)).timeIntervalSince1970 * 1000
                ])
            }
        }
        return grouped.keys.sorted().map { at in ["groupId": "\(memberId):\(at)", "memberId": memberId,
            "scheduledAt": at, "timeZone": TimeZone.current.identifier, "occurrences": grouped[at]!] }
    }
    private func alarmID(_ group: String) -> UUID {
        let hex = SHA256.hash(data: Data(group.utf8)).prefix(16).map { String(format: "%02x", $0) }.joined()
        let chars = Array(hex)
        let text = [String(chars[0..<8]), String(chars[8..<12]), String(chars[12..<16]),
                    String(chars[16..<20]), String(chars[20..<32])].joined(separator: "-")
        return UUID(uuidString: text)!
    }
}

@available(iOS 26.0, *)
private struct MedicationAlarmMetadata: AlarmMetadata {}

@available(iOS 26.0, *)
struct OpenMedicationIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "복용 인증하기"
    static var openAppWhenRun: Bool = true
    @Parameter(title: "Alarm ID") var alarmID: String
    init() { alarmID = "" }
    init(alarmID: String) { self.alarmID = alarmID }
    func perform() async throws -> some IntentResult {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            Task { @MainActor in
                MedicationAlarmCoordinator.shared.enqueue {
                    try? MedicationAlarmCoordinator.shared.open(id: alarmID)
                    continuation.resume()
                }
            }
        }
        return .result()
    }
}
