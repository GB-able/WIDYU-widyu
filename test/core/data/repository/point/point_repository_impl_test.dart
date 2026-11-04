import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/point/point_repository_impl.dart';
import 'package:widyu/core/data/source/point/point_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';

void main() {
  test('요청 전에 읽은 revision 뒤로 refresh가 시작됐으면 화면 응답을 무시한다', () async {
    final remote = _Remote()..points = 100;
    final repository = PointRepositoryImpl(remoteDataSource: remote);
    await repository.refresh();

    final revision = repository.revision;
    remote.points = 50;
    await repository.refresh();

    repository.sync(100, revision: revision);
    expect(repository.currentStatus.point, 50);

    repository.sync(70, revision: repository.revision);
    expect(repository.currentStatus.point, 70);
    repository.dispose();
  });
}

class _Remote implements PointRemoteDataSource {
  int points = 0;

  @override
  Future<ApiResponse<int>> fetchPoints() async => ApiResponse(
        statusCode: 200,
        code: 'OK',
        message: '',
        data: points,
      );
}
