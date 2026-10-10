import 'package:widyu/core/model/location/location_update_request.dart';
import 'package:widyu/core/network/socket_client.dart';

import 'location_remote_data_source.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final SocketClient _socketClient;

  LocationRemoteDataSourceImpl({required SocketClient socketClient})
      : _socketClient = socketClient;

  @override
  Stream<bool> get connectionState => _socketClient.connectionState;

  @override
  bool sendLocation(LocationUpdateRequest request) =>
      _socketClient.sendLocation(request.toJson());
}
