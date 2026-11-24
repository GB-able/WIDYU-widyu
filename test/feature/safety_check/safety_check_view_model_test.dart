import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/incident/incident_respond_result.dart';
import 'package:widyu/core/model/incident/prompt_displayed_result.dart';
import 'package:widyu/feature/safety_check/safety_check_ui_state.dart';
import 'package:widyu/feature/safety_check/safety_check_view_model.dart';

class _Repository extends Fake implements IncidentRepository {
  int? respondByMs;
  ApiResult<IncidentRespondResult> respondResult = const ApiResult.success(
      IncidentRespondResult(incidentId: 'inc-1', state: 'OK_CLOSED'));

  @override
  Future<ApiResult<PromptDisplayedResult>> markPromptDisplayed(
          String incidentId) async =>
      ApiResult.success(PromptDisplayedResult(
          incidentId: incidentId, respondByMs: respondByMs));

  @override
  Future<ApiResult<IncidentRespondResult>> respondOk(String incidentId) async =>
      respondResult;
}

void main() {
  (SafetyCheckUiState Function(), SafetyCheckViewModel) create(
      _Repository repository) {
    final container = ProviderContainer(
      overrides: [incidentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final provider = safetyCheckViewModelProvider('inc-1');
    final subscription = container.listen(provider, (_, __) {});
    return (subscription.read, container.read(provider.notifier));
  }

  test('응답 마감이 지나면 안괜찮음을 3초 보여준 뒤 닫는다', () {
    fakeAsync((async) {
      final repository = _Repository()
        ..respondByMs = DateTime.now()
            .add(const Duration(seconds: 30))
            .millisecondsSinceEpoch;
      final (state, _) = create(repository);
      async.elapse(const Duration(seconds: 29));
      expect(state().phase, SafetyCheckPhase.confirm);
      async.elapse(const Duration(seconds: 2));
      expect(state().phase, SafetyCheckPhase.notOkay);
      expect(state().closed, isFalse);
      async.elapse(const Duration(seconds: 3));
      expect(state().closed, isTrue);
    });
  });

  test('마감 안에 응답하면 괜찮음을 보여주고 마감 타이머는 무시한다', () {
    fakeAsync((async) {
      final (state, viewModel) = create(_Repository());
      SafetyRespondResult? result;
      viewModel.respondOk().then((value) => result = value);
      async.flushMicrotasks();
      expect(result, SafetyRespondResult.sent);
      expect(state().phase, SafetyCheckPhase.okay);
      async.elapse(const Duration(seconds: 60));
      expect(state().phase, SafetyCheckPhase.okay);
      expect(state().closed, isTrue);
    });
  });

  test('서버가 늦은 응답으로 처리하면 안괜찮음을 보여준다', () {
    fakeAsync((async) {
      final repository = _Repository()
        ..respondResult = const ApiResult.success(
            IncidentRespondResult(incidentId: 'inc-1', state: 'ESCALATED'));
      final (state, viewModel) = create(repository);
      viewModel.respondOk();
      async.flushMicrotasks();
      expect(state().phase, SafetyCheckPhase.notOkay);
    });
  });

  test('응답 실패 시 확인 화면을 유지하고 실패를 돌려준다', () {
    fakeAsync((async) {
      final repository = _Repository()
        ..respondResult = const ApiResult.failure('network');
      final (state, viewModel) = create(repository);
      SafetyRespondResult? result;
      viewModel.respondOk().then((value) => result = value);
      async.flushMicrotasks();
      expect(result, SafetyRespondResult.failed);
      expect(state().phase, SafetyCheckPhase.confirm);
      expect(state().isSubmitting, isFalse);
    });
  });
}
