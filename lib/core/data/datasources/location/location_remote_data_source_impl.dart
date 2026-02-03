import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:widyu/core/network/token_manager.dart';

import '../../models/location/user_location.dart';
import 'location_remote_data_source.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  StompClient? _stompClient;
  final _tokenManager = TokenManager();

  static String baseUrl = dotenv.env['BASE_URL']!;
  static const String socketPrefix = '/ws/location';
  static const String subscribeDestination = '/topic/location/senior';
  static const String sendDestination = '/app/location/update';

  @override
  Future<void> connect() async {
    const String memberId = '1';
    final accessToken = await _tokenManager.accessToken;

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$baseUrl$socketPrefix',
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
    if (_stompClient?.connected == true) {
      _stompClient!.send(
        destination: sendDestination,
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

  void _onConnect(String memberId) {
    _stompClient?.subscribe(
      destination: '$subscribeDestination/$memberId',
      callback: (frame) {
        log('Received message: ${frame.body}');
      },
    );
  }
}
