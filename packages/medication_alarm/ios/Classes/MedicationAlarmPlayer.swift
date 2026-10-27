import AVFoundation
import AudioToolbox
import UIKit

@MainActor
final class MedicationAlarmPlayer {
    static let shared = MedicationAlarmPlayer()
    static let keepaliveLead: TimeInterval = 15 * 60
    static let maxRing: TimeInterval = 10 * 60
    static let hapticInterval: TimeInterval = 2
    static let heartbeatInterval: TimeInterval = 60
    static let watchdogDelay: TimeInterval = 120
    var sound = true
    var haptics = true
    var onFire: ((UUID) -> Void)?
    var onStop: (() -> Void)?
    var onHeartbeat: (() -> Void)?
    var onIdle: (() -> Void)?
    var engaged: Bool { silence != nil || alarm != nil }
    private(set) var ringingID: UUID?
    private(set) var lastFired: UUID?
    private let session = AVAudioSession.sharedInstance()
    private var silence: AVAudioPlayer?
    private var alarm: AVAudioPlayer?
    private var keepaliveTimer: Timer?
    private var fireTimer: Timer?
    private var ceilingTimer: Timer?
    private var hapticTimer: Timer?
    private var heartbeat: Timer?
    private var observer: NSObjectProtocol?

    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        observer = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] note in
            MainActor.assumeIsolated { self?.interrupted(note) }
        }
    }

    func arm(next: (id: UUID, at: Date)?) {
        keepaliveTimer?.invalidate(); keepaliveTimer = nil
        fireTimer?.invalidate(); fireTimer = nil
        guard let next else {
            if ringingID == nil { stopKeepalive() }
            return
        }
        let lead = next.at.timeIntervalSinceNow
        let fire = Timer(fire: next.at.addingTimeInterval(-1), interval: 0, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.fire(next.id) }
        }
        RunLoop.main.add(fire, forMode: .common)
        fireTimer = fire
        if lead <= Self.keepaliveLead {
            startKeepalive()
        } else {
            if ringingID == nil { stopKeepalive() }
            let keepalive = Timer(fire: next.at.addingTimeInterval(-Self.keepaliveLead), interval: 0, repeats: false) { [weak self] _ in
                MainActor.assumeIsolated { self?.startKeepalive() }
            }
            RunLoop.main.add(keepalive, forMode: .common)
            keepaliveTimer = keepalive
        }
        log("armed id=\(next.id.uuidString) at=\(next.at) leadSec=\(Int(lead))")
    }

    func stop() {
        hapticTimer?.invalidate(); hapticTimer = nil
        ceilingTimer?.invalidate(); ceilingTimer = nil
        alarm?.stop(); alarm = nil
        guard ringingID != nil else { refreshHeartbeat(); return }
        ringingID = nil
        log("stop battery=\(battery)")
        onStop?()
        refreshHeartbeat()
    }

    private func refreshHeartbeat() {
        if engaged, heartbeat == nil {
            heartbeat = Timer.scheduledTimer(withTimeInterval: Self.heartbeatInterval, repeats: true) { [weak self] _ in
                MainActor.assumeIsolated { self?.onHeartbeat?() }
            }
            onHeartbeat?()
        } else if !engaged, heartbeat != nil {
            heartbeat?.invalidate(); heartbeat = nil
            onIdle?()
        }
    }

    func disarm() {
        stop()
        arm(next: nil)
    }

    func startForeground(id: UUID) {
        fire(id)
    }

    private func fire(_ id: UUID) {
        guard ringingID == nil else { return }
        ringingID = id
        lastFired = id
        fireTimer = nil
        if sound { startAudio() }
        if haptics { startHaptics() }
        ceilingTimer = Timer.scheduledTimer(withTimeInterval: Self.maxRing, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.stop() }
        }
        log("fire id=\(id.uuidString) state=\(UIApplication.shared.applicationState.rawValue) battery=\(battery)")
        onFire?(id)
    }

    private func activate() throws {
        try session.setCategory(.playback, mode: .default, options: [])
        try session.setActive(true)
    }

    private func player(_ name: String) throws -> AVAudioPlayer {
        guard let url = Bundle(for: MedicationAlarmPlayer.self).url(forResource: name, withExtension: "caf") else {
            throw NSError(domain: "MedicationAlarmPlayer", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(name).caf missing"])
        }
        let player = try AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        player.volume = 1
        return player
    }

    private func startKeepalive() {
        guard silence?.isPlaying != true, alarm == nil else { return }
        do {
            try activate()
            let player = try player("medication_silence")
            player.play()
            silence = player
            log("keepalive start battery=\(battery)")
        } catch { log("keepalive error \(error)") }
        refreshHeartbeat()
    }

    private func stopKeepalive() {
        if silence != nil {
            silence?.stop(); silence = nil
            log("keepalive stop battery=\(battery)")
        }
        if alarm == nil { try? session.setActive(false, options: .notifyOthersOnDeactivation) }
        refreshHeartbeat()
    }

    private func startAudio() {
        do {
            try activate()
            silence?.stop(); silence = nil
            let player = try player("medication_alarm")
            player.play()
            alarm = player
        } catch { log("audio error \(error)") }
        refreshHeartbeat()
    }

    private func startHaptics() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        hapticTimer = Timer.scheduledTimer(withTimeInterval: Self.hapticInterval, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }

    private func interrupted(_ note: Notification) {
        guard let raw = note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              AVAudioSession.InterruptionType(rawValue: raw) == .ended else { return }
        try? session.setActive(true)
        alarm?.play()
        silence?.play()
        log("interruption ended")
    }

    private var battery: String { String(format: "%.0f%%", UIDevice.current.batteryLevel * 100) }

    func log(_ message: String) {
        #if DEBUG
        let stamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("alarm.log"),
              let data = "\(message) @\(stamp)\n".data(using: .utf8) else { return }
        if let handle = try? FileHandle(forWritingTo: url) { handle.seekToEndOfFile(); handle.write(data); handle.closeFile() }
        else { try? data.write(to: url) }
        #endif
    }
}
