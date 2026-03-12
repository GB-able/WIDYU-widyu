import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/network/socket_client.dart';

import 'location_remote_data_source.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final SocketClient _socketClient;

  LocationRemoteDataSourceImpl({required SocketClient socketClient})
      : _socketClient = socketClient;

  @override
  void sendLocation(UserLocation location) {
    _socketClient.sendLocation(location);
  }
}
