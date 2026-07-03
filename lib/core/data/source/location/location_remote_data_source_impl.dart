import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/network/token_manager.dart';

import 'location_remote_data_source.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final SocketClient _socketClient;
  final TokenManager _tokenManager = TokenManager();

  LocationRemoteDataSourceImpl({required SocketClient socketClient})
      : _socketClient = socketClient;

  @override
  void sendLocation(UserLocation location) async {
    final memberId = await _tokenManager.memberId;
    _socketClient.sendLocation(location.copyWith(memberId: memberId));
  }
}
