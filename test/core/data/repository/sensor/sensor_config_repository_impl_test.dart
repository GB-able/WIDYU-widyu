import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/sensor/sensor_config_repository_impl.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';

void main() {
  late _Remote remote;
  late _Local local;
  late SensorConfigRepositoryImpl repository;

  setUp(() {
    remote = _Remote();
    local = _Local();
    repository = SensorConfigRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
    );
  });

  tearDown(() => repository.stop());

  testWidgets('시작하면 조회한 설정을 워치로 내린다', (tester) async {
    remote.config = const SensorConfig(accFsHz: 100, refreshSec: 5);

    repository.start();
    await tester.pump();

    expect(remote.fetchCount, 1);
    expect(local.sent.single.accFsHz, 100);
    repository.stop();
  });

  testWidgets('refreshSec 이 지나면 다시 조회한다', (tester) async {
    remote.config = const SensorConfig(refreshSec: 5);

    repository.start();
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();

    expect(remote.fetchCount, 2);
    expect(local.sent, hasLength(2));
    repository.stop();
  });

  testWidgets('조회 실패 시 워치로 내리지 않고 기본 주기 뒤 재시도한다', (tester) async {
    remote.config = null;

    repository.start();
    await tester.pump();
    expect(local.sent, isEmpty);

    remote.config = const SensorConfig();
    await tester.pump(const Duration(seconds: 60));
    await tester.pump();

    expect(remote.fetchCount, 2);
    expect(local.sent, hasLength(1));
    repository.stop();
  });
}

class _Remote implements SensorConfigRemoteDataSource {
  SensorConfig? config;
  int fetchCount = 0;

  @override
  Future<SensorConfig?> fetch() async {
    fetchCount++;
    return config;
  }
}

class _Local implements SensorConfigLocalDataSource {
  final sent = <SensorConfig>[];

  @override
  Future<void> sendToWatch(SensorConfig config) async => sent.add(config);
}
