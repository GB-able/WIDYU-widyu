import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:widyu/feature/home/home_screen.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/home_view_model.dart';

class _FakeHomeViewModel extends HomeViewModel {
  @override
  HomeUiState build() => HomeUiState.init()
      .copyWith(isInitialLoading: true, isSeniorCardLoading: true);

  void emit(HomeUiState next) => state = next;
}

void main() {
  testWidgets('스켈레톤과 캐러셀을 오가도 PageView가 컨트롤러에 둘 붙지 않는다', (tester) async {
    await initializeDateFormatting('ko_KR');
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    dotenv.loadFromString(
        envString: 'BASE_URL=http://localhost', isOptional: true);
    final container = ProviderContainer(
      overrides: [homeViewModelProvider.overrideWith(_FakeHomeViewModel.new)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: HomeScreen()),
    ));
    await tester.pump();

    final viewModel =
        container.read(homeViewModelProvider.notifier) as _FakeHomeViewModel;
    final loaded = HomeUiState.init().copyWith(stepGoal: 5000);
    for (final next in [
      loaded,
      loaded.copyWith(isSeniorCardLoading: true),
      loaded,
    ]) {
      viewModel.emit(next);
      await tester.pump();
      expect(tester.takeException(), isNull);
    }

    // 카드 타이머를 정리한다.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  });
}
