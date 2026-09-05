import CoreMotion
import Flutter
import UIKit
import flutter_background_service_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
  // [NOTICE] 자정부터 현재까지의 걸음 수를 조회하는 채널.
  private static let stepChannelName = "com.example.widyu/step_counter"

  private let pedometer = CMPedometer()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.example.widyu.refresh"
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

    if let controller = window?.rootViewController as? FlutterViewController {
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
