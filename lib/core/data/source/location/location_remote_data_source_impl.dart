import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/network/token_manager.dart';

import 'location_remote_data_source.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final TokenManager _tokenManager;
  StompClient? _stompClient;

  LocationRemoteDataSourceImpl({required TokenManager tokenManager})
      : _tokenManager = tokenManager;

  String get _baseUrl => dotenv.env['BASE_URL'] ?? "";
  static const String _socketPrefix = '/ws/location';
  static const String _subscribeDestination = '/topic/location/senior';
  static const String _sendDestination = '/app/location/update';

  @override
  Future<void> connect() async {
    final accessToken = await _tokenManager.accessToken;
    final memberId = await _tokenManager.memberId;

    _stompClient?.deactivate();
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$_baseUrl$_socketPrefix',
        onConnect: (StompFrame frame) {
          _onConnect(memberId);
        },
        onWebSocketError: (dynamic error) {
          log('WebSocket Error: ${error.toString()}');
        },
        onStompError: (StompFrame frame) {
          log('STOMP Error: ${frame.body}');
        },
        stompConnectHeaders: {'Authorization': 'Bearer $accessToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    _stompClient!.activate();
  }

  @override
  void sendLocation(UserLocation location) {
    if (_stompClient != null && _stompClient?.connected == true) {
      _stompClient!.send(
        destination: _sendDestination,
        body: jsonEncode(location.toJson()),
      );
    } else {
      log('STOMP client is not connected, cannot send location.');
    }
  }

  @override
  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
  }

  void _onConnect(String? memberId) {
    _stompClient?.subscribe(
      destination: '$_subscribeDestination/$memberId',
      callback: (frame) {
        log('Received message: ${frame.body}');
      },
    );
  }
}
