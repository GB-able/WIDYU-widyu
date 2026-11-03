import Flutter
import UIKit
import UserNotifications

public class MedicationAlarmPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var sink: FlutterEventSink?
    private var observer: NSObjectProtocol?
    public func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        MainActor.assumeIsolated { MedicationAlarmCoordinator.shared.registerBackground() }
        return true
    }
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MedicationAlarmPlugin()
        registrar.addMethodCallDelegate(instance, channel: FlutterMethodChannel(
            name: "com.widucorp.widu/medication_alarm", binaryMessenger: registrar.messenger()))
        FlutterEventChannel(name: "com.widucorp.widu/medication_alarm/events", binaryMessenger: registrar.messenger())
            .setStreamHandler(instance)
        registrar.addApplicationDelegate(instance)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task { @MainActor in
            MedicationAlarmCoordinator.shared.enqueue {
                do { result(try await MedicationAlarmCoordinator.shared.handle(call.method, args: call.arguments as? [String: Any] ?? [:])) }
                catch { result(FlutterError(code: "MEDICATION_ALARM", message: error.localizedDescription, details: nil)) }
            }
        }
    }
    public func applicationWillTerminate(_ application: UIApplication) {
        MainActor.assumeIsolated { MedicationAlarmCoordinator.shared.terminated() }
    }
    public func applicationDidBecomeActive(_ application: UIApplication) {
        MainActor.assumeIsolated { MedicationAlarmCoordinator.shared.enqueue { try? MedicationAlarmCoordinator.shared.resumed() } }
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        observer = NotificationCenter.default.addObserver(forName: .medicationAlarmChanged, object: nil, queue: .main) { [weak self] _ in self?.sink?(nil) }
        return nil
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if let observer { NotificationCenter.default.removeObserver(observer) }
        observer = nil; sink = nil
        return nil
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard notification.request.identifier.hasPrefix("widyu.medication.") else { return }
        completionHandler([.banner, .list, .sound])
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard response.notification.request.identifier.hasPrefix("widyu.medication.") else { return }
        let id = String(response.notification.request.identifier.dropFirst("widyu.medication.".count))
        Task { @MainActor in
            MedicationAlarmCoordinator.shared.enqueue {
                switch response.actionIdentifier {
                case UNNotificationDismissActionIdentifier: break
                case "MEDICATION_STOP": MedicationAlarmCoordinator.shared.stopRinging(id: id)
                default: try? MedicationAlarmCoordinator.shared.open(id: id)
                }
                completionHandler()
            }
        }
    }
    deinit { if let observer { NotificationCenter.default.removeObserver(observer) } }
}

extension Notification.Name { static let medicationAlarmChanged = Notification.Name("widyu.medication.changed") }
