import Flutter
import UIKit
import flutter_background_service_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
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
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
