import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/feature/home/home_screen.dart';

void main() {
  testWidgets('메시 배경은 여러 개여도 초당 약 12번만 그리고, 화면 밖·백그라운드에서 멈췄다가 돌아오면 다시 움직인다',
      (tester) async {
    var frames = 0;
    tester.binding.addPersistentFrameCallback((_) => frames++);

    // 메시는 깨어날 때마다 clock.now()를 한 번 읽는다. 백그라운드에서는 프레임이
    // 그려지지 않아 프레임 수로는 멈췄는지 알 수 없으므로, 깨어난 횟수를 센다.
    final fakeClock = clock;
    var wakeUps = 0;
    await withClock(Clock(() {
      wakeUps++;
      return fakeClock.now();
    }), () async {
      // 60Hz vsync를 흉내 내 약 1초 동안 그려진 프레임 수를 센다.
      Future<int> framesInASecond() async {
        frames = 0;
        for (var i = 0; i < 60; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
        return frames;
      }

      Widget app({required bool visible, required int count}) => Directionality(
            textDirection: TextDirection.ltr,
            child: TickerMode(
              enabled: visible,
              child: Column(
                children: [
                  for (var i = 0; i < count; i++)
                    const Expanded(
                      child: MeshGradientBackground(
                        baseColor: Colors.white,
                        blobs: [],
                      ),
                    ),
                ],
              ),
            ),
          );

      await tester.pumpWidget(app(visible: true, count: 1));
      // 두 번째 메시는 다른 시각에 붙여도 같은 눈금에 깨어나야 한다.
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pumpWidget(app(visible: true, count: 2));
      expect(await framesInASecond(), inInclusiveRange(10, 13));

      await tester.pumpWidget(app(visible: false, count: 2));
      expect(await framesInASecond(), 0);

      // 탭으로 돌아오면 다시 움직인다.
      await tester.pumpWidget(app(visible: true, count: 2));
      expect(await framesInASecond(), inInclusiveRange(10, 13));

      // 백그라운드에서는 타이머가 깨어나지 않고, 돌아오면 다시 움직인다.
      // inactive는 프레임이 켜진 상태라 paused로 보내야 타이머가 멈춘다.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      final wakeUpsBeforePause = wakeUps;
      await tester.pump(const Duration(seconds: 1));
      expect(wakeUps, wakeUpsBeforePause);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(await framesInASecond(), inInclusiveRange(10, 13));
    });
  });
}
