import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/util/extension/medication_extension.dart';

void main() {
  test('자정을 넘는 알람도 전후 30분 그대로 인증할 수 있다', () {
    final late = DateTime(2026, 11, 19, 23, 45);
    expect(late.windowClosesAt, DateTime(2026, 11, 20, 0, 15));
    expect(late.isWithinVerifyWindow(DateTime(2026, 11, 20, 0, 5)), isTrue);
    expect(late.isWithinVerifyWindow(DateTime(2026, 11, 20, 0, 16)), isFalse);

    final early = DateTime(2026, 11, 20, 0, 10);
    expect(early.windowOpensAt, DateTime(2026, 11, 19, 23, 40));
    expect(early.isWithinVerifyWindow(DateTime(2026, 11, 19, 23, 39)), isFalse);
  });
}
