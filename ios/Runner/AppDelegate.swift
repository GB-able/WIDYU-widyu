import BackgroundTasks
import CoreMotion
import Flutter
import HealthKit
import UIKit
import flutter_background_service_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
  // [NOTICE] 자정부터 현재까지의 걸음 수를 조회하는 채널.
  private static let stepChannelName = "com.example.widyu/step_counter"

  private let pedometer = CMPedometer()
  private let stepBackground = StepBackgroundCoordinator()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    stepBackground.launch()
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.example.widyu.refresh"
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

    if let controller = window?.rootViewController as? FlutterViewController {
      stepBackground.attach(to: controller.binaryMessenger)
      let channel = FlutterMethodChannel(
        name: AppDelegate.stepChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handleStepChannel(call: call, result: result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleStepChannel(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      result(CMPedometer.isStepCountingAvailable())

    case "authorizationStatus":
      // 0: notDetermined, 1: restricted, 2: denied, 3: authorized
      result(CMPedometer.authorizationStatus().rawValue)

    case "querySteps":
      guard CMPedometer.isStepCountingAvailable() else {
        result(FlutterError(code: "UNAVAILABLE", message: "걸음 수 측정을 지원하지 않는 기기입니다.", details: nil))
        return
      }
      guard let args = call.arguments as? [String: Any],
            let startMillis = args["startMillis"] as? NSNumber,
            let endMillis = args["endMillis"] as? NSNumber
      else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "조회 구간이 올바르지 않습니다.", details: nil))
        return
      }

      let start = Date(timeIntervalSince1970: startMillis.doubleValue / 1000)
      let end = Date(timeIntervalSince1970: endMillis.doubleValue / 1000)

      pedometer.queryPedometerData(from: start, to: end) { data, error in
        DispatchQueue.main.async {
          if let error = error as NSError? {
            result(FlutterError(code: "QUERY_FAILED", message: error.localizedDescription, details: nil))
            return
          }
          result(data?.numberOfSteps.intValue ?? 0)
        }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

private final class StepBackgroundCoordinator {
  private static let taskIdentifier = "com.example.widyu.steps.refresh"
  private static let enabledKey = "widyu.steps.background.enabled"
  private static let callbackKey = "widyu.steps.background.callback"
  private static let pendingKey = "widyu.steps.background.pending"

  private let healthStore = HKHealthStore()
  private let defaults = UserDefaults.standard
  private var observer: HKObserverQuery?
  private var foregroundChannel: FlutterMethodChannel?
  private var foregroundReady = false
  private var engine: FlutterEngine?
  private var workerChannel: FlutterMethodChannel?
  private var workerControlChannel: FlutterMethodChannel?
  private var timeout: DispatchWorkItem?
  private var runIdentifier: UUID?
  private var completions: [(Bool) -> Void] = []
  private var backgroundTask = UIBackgroundTaskIdentifier.invalid
  private var protectedDataObserver: NSObjectProtocol?

  func launch() {
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: Self.taskIdentifier,
      using: .main
    ) { [weak self] task in
      guard let self = self else {
        task.setTaskCompleted(success: false)
        return
      }
      self.scheduleRefresh()
      task.expirationHandler = { [weak self] in
        DispatchQueue.main.async {
          guard let self = self, let identifier = self.runIdentifier else { return }
          self.finish(identifier, succeeded: false)
        }
      }
      self.run { success in task.setTaskCompleted(success: success) }
    }
    protectedDataObserver = NotificationCenter.default.addObserver(
      forName: UIApplication.protectedDataDidBecomeAvailableNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self, self.defaults.bool(forKey: Self.pendingKey) else { return }
      self.run { _ in }
    }
    if defaults.bool(forKey: Self.enabledKey) {
      registerObserver()
      scheduleRefresh()
    }
  }

  func attach(to messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "com.example.widyu/step_background",
      binaryMessenger: messenger
    )
    foregroundChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(FlutterError(code: "UNAVAILABLE", message: "걸음수 서비스가 종료되었습니다.", details: nil))
        return
      }
      switch call.method {
      case "initialize":
        guard let callback = call.arguments as? NSNumber else {
          result(FlutterError(code: "INVALID_CALLBACK", message: "백그라운드 진입점이 없습니다.", details: nil))
          return
        }
        self.defaults.set(callback.int64Value, forKey: Self.callbackKey)
        self.foregroundReady = true
        result(nil)
      case "enable":
        guard HKHealthStore.isHealthDataAvailable(),
              let type = HKObjectType.quantityType(forIdentifier: .stepCount) else {
          result(FlutterError(code: "UNAVAILABLE", message: "건강 데이터를 지원하지 않는 기기입니다.", details: nil))
          return
        }
        self.defaults.set(true, forKey: Self.enabledKey)
        self.registerObserver()
        self.scheduleRefresh()
        self.healthStore.enableBackgroundDelivery(for: type, frequency: .hourly) { success, error in
          DispatchQueue.main.async {
            if !self.defaults.bool(forKey: Self.enabledKey) {
              self.healthStore.disableBackgroundDelivery(for: type) { _, _ in }
            }
            if success {
              result(nil)
            } else {
              result(FlutterError(code: "BACKGROUND_UNAVAILABLE", message: error?.localizedDescription ?? "백그라운드 건강 데이터 알림을 사용할 수 없습니다.", details: nil))
            }
          }
        }
      case "disable":
        self.disableScheduling(stopCurrentRun: true)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func disableScheduling(stopCurrentRun: Bool) {
    defaults.set(false, forKey: Self.enabledKey)
    defaults.removeObject(forKey: Self.pendingKey)
    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.taskIdentifier)
    if let observer = observer {
      healthStore.stop(observer)
      self.observer = nil
    }
    if stopCurrentRun, let identifier = runIdentifier {
      finish(identifier, succeeded: false)
    }
    if let type = HKObjectType.quantityType(forIdentifier: .stepCount) {
      healthStore.disableBackgroundDelivery(for: type) { _, _ in }
    }
  }

  private func registerObserver() {
    guard observer == nil, HKHealthStore.isHealthDataAvailable(),
          let type = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
    let query = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completion, error in
      DispatchQueue.main.async {
        guard let self = self else {
          completion()
          return
        }
        guard error == nil else {
          self.defaults.set(true, forKey: Self.pendingKey)
          self.scheduleRefresh()
          completion()
          return
        }
        self.run { _ in completion() }
      }
    }
    observer = query
    healthStore.execute(query)
  }

  private func scheduleRefresh() {
    guard defaults.bool(forKey: Self.enabledKey) else { return }
    let request = BGAppRefreshTaskRequest(identifier: Self.taskIdentifier)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      NSLog("[steps] Background refresh scheduling unavailable")
    }
  }

  private func run(completion: @escaping (Bool) -> Void) {
    guard defaults.bool(forKey: Self.enabledKey) else {
      completion(false)
      return
    }
    defaults.set(true, forKey: Self.pendingKey)
    guard UIApplication.shared.isProtectedDataAvailable else {
      completion(false)
      return
    }
    completions.append(completion)
    guard runIdentifier == nil else { return }
    let identifier = UUID()
    runIdentifier = identifier
    let deadline = DispatchWorkItem { [weak self] in
      self?.finish(identifier, succeeded: false)
    }
    timeout = deadline
    DispatchQueue.main.asyncAfter(deadline: .now() + 25, execute: deadline)

    if UIApplication.shared.applicationState == .active,
       foregroundReady, let channel = foregroundChannel {
      channel.invokeMethod("sync", arguments: nil) { [weak self] result in
        self?.finish(identifier, succeeded: result == nil)
      }
      return
    }

    backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "widyu.steps.sync") { [weak self] in
      self?.finish(identifier, succeeded: false)
    }
    guard let handle = defaults.object(forKey: Self.callbackKey) as? NSNumber,
          let callback = FlutterCallbackCache.lookupCallbackInformation(handle.int64Value) else {
      finish(identifier, succeeded: false)
      return
    }
    let backgroundEngine = FlutterEngine(
      name: "widyu.steps.\(identifier.uuidString)",
      project: nil,
      allowHeadlessExecution: true
    )
    engine = backgroundEngine
    guard backgroundEngine.run(
      withEntrypoint: callback.callbackName,
      libraryURI: callback.callbackLibraryPath
    ) else {
      finish(identifier, succeeded: false)
      return
    }
    GeneratedPluginRegistrant.register(with: backgroundEngine)
    let controlChannel = FlutterMethodChannel(
      name: "com.example.widyu/step_background",
      binaryMessenger: backgroundEngine.binaryMessenger
    )
    workerControlChannel = controlChannel
    controlChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self, self.runIdentifier == identifier else {
        result(FlutterError(code: "UNAVAILABLE", message: "걸음수 작업이 종료되었습니다.", details: nil))
        return
      }
      guard call.method == "disable" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.disableScheduling(stopCurrentRun: false)
      result(nil)
    }
    let channel = FlutterMethodChannel(
      name: "com.example.widyu/step_background_worker",
      binaryMessenger: backgroundEngine.binaryMessenger
    )
    workerChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "ready":
        result(nil)
      case "complete":
        result(nil)
        DispatchQueue.main.async {
          self?.finish(identifier, succeeded: call.arguments as? Bool ?? false)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func finish(_ identifier: UUID, succeeded: Bool) {
    guard runIdentifier == identifier else { return }
    runIdentifier = nil
    timeout?.cancel()
    timeout = nil
    if succeeded {
      defaults.removeObject(forKey: Self.pendingKey)
    }
    let callbacks = completions
    completions.removeAll()
    let finishedEngine = engine
    engine = nil
    workerChannel?.setMethodCallHandler(nil)
    workerChannel = nil
    workerControlChannel?.setMethodCallHandler(nil)
    workerControlChannel = nil
    if backgroundTask != .invalid {
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = .invalid
    }
    callbacks.forEach { $0(succeeded) }
    if let finishedEngine = finishedEngine {
      DispatchQueue.main.async { finishedEngine.destroyContext() }
    }
  }
}
