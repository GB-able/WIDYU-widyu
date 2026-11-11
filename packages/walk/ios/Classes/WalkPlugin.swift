import CoreMotion
import Flutter

public class WalkPlugin: NSObject, FlutterPlugin {
  private let pedometer = CMPedometer()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.widucorp.widu/step_counter",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(WalkPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      result(CMPedometer.isStepCountingAvailable())

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
          if let error = error {
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
