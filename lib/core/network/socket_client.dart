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

  Future<void> connect(String token) async {
    // `_isConnected` 는 activate() 직후부터 onConnect 사이 구간에서 false 이므로,
    // 그 사이에 다시 불리면 두 번째 클라이언트가 만들어지고 첫 번째는 참조를 잃은 채
    // reconnectDelay(기본 5초) 마다 재연결을 계속 시도한다. 인스턴스 유무로 막는다.
    if (_stompClient != null) return;

    final memberId = await _tokenManager.memberId;
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$_baseUrl$_socketPrefix?token=$token',
        onConnect: (StompFrame frame) {
          _onConnect(memberId);
        },
        onWebSocketError: (dynamic error) {
          log('WebSocket Error: ${error.toString()}');
        },
        onStompError: (StompFrame frame) {
          log('STOMP Error: ${frame.body}');
        },
      ),
    );
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
