import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:widyu/core/model/heartRate/heart_rate_request.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/network/token_manager.dart';

class SocketClient {
  static final SocketClient _instance = SocketClient._internal();

  factory SocketClient() => _instance;

  SocketClient._internal();

  final TokenManager _tokenManager = TokenManager();
  StompClient? _stompClient;

  String get _baseUrl => dotenv.env['BASE_URL'] ?? "";

  bool get _isConnected => _stompClient?.connected ?? false;

  static const String _socketPrefix = '/ws/location';
  static const String _subscribeDestination = '/topic/location/senior';
  static const String _locationDestination = '/app/location/update';
  static const String _heartRateDestination = '/app/heart-rate/send';

  Future<void> connect() async {
    if (_isConnected) return;

    final accessToken = await _tokenManager.accessToken;
    final memberId = await _tokenManager.memberId;

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
    if (_isConnected) {
      _stompClient!.send(
        destination: _locationDestination,
        body: jsonEncode(location.toJson()),
      );
    } else {
      log("Socket Client is not connected, cannot send location.");
    }
  }

  void sendHeartRates(HeartRateRequest heartRateRequest) {
    if (_isConnected) {
      _stompClient!.send(
        destination: _heartRateDestination,
        body: jsonEncode(heartRateRequest.toJson()),
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
