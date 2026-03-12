import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:widyu/core/model/heartRate/heart_rate.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/network/token_manager.dart';

class SocketClient {
  final TokenManager _tokenManager;
  StompClient? _stompClient;

  SocketClient({required TokenManager tokenManager})
      : _tokenManager = tokenManager;

  String get _baseUrl => dotenv.env['BASE_URL'] ?? "";

  bool get isConnected => _stompClient?.connected ?? false;

  static const String _socketPrefix = '/ws/location';
  static const String _subscribeDestination = '/topic/location/senior';
  static const String _locationDestination = '/app/location/update';
  static const String _heartRateDestination = '/app/heart-rate/send';

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
    ));
    _stompClient!.activate();
  }

  void sendLocation(UserLocation location) {
    if (isConnected) {
      _stompClient!.send(
        destination: _locationDestination,
        body: jsonEncode(location.toJson()),
      );
    } else {
      log("Socket Client is not connected, cannot send location.");
    }
  }

  void sendHeartRate(HeartRate heartRate) {
    if (isConnected) {
      _stompClient!.send(
        destination: _heartRateDestination,
        body: jsonEncode(heartRate.toJson()),
      );
    } else {
      log("Socket Client is not connected, cannot send heartRate.");
    }
  }

  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
  }

  void _onConnect(String? memberId) {
    if (memberId == null) {
      log("Member ID is null.");
      return;
    }

    _stompClient?.subscribe(
      destination: '$_subscribeDestination/$memberId',
      callback: (frame) {
        log('Received message: ${frame.body}');
      },
    );
  }
}
