import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:widyu/core/model/heartRate/heart_rate_request.dart';
import 'package:widyu/core/model/location/user_location.dart';

class SocketClient {
  static final SocketClient _instance = SocketClient._internal();

  factory SocketClient() => _instance;

  SocketClient._internal();

  StompClient? _stompClient;

  String get _baseUrl => dotenv.env['BASE_URL'] ?? "";

  bool get _isConnected => _stompClient?.connected ?? false;

  static const String _socketPrefix = '/ws/location';
  static const String _locationDestination = '/app/location/update';
  static const String _heartRateDestination = '/app/heart-rate/send';

  void connect(String token) {
    if (_stompClient != null) return;

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$_baseUrl$_socketPrefix?token=$token',
        onConnect: (StompFrame frame) {
          log('Socket connected.');
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

  void sendLocation(UserLocation location) => _send(
        _locationDestination,
        location.toJson(),
        'location',
      );

  void sendHeartRates(HeartRateRequest heartRateRequest) => _send(
        _heartRateDestination,
        heartRateRequest.toJson(),
        'heart rates',
      );

  void _send(
    String destination,
    Map<String, dynamic> json,
    String label,
  ) {
    if (!_isConnected) {
      log("Socket Client is not connected, cannot send $label.");
      return;
    }

    final body = jsonEncode(json);
    try {
      _stompClient!.send(destination: destination, body: body);
    } on StompBadStateException catch (e) {
      log("Failed to send $label: $e");
    }
  }

  void disconnect() {
    _stompClient?.deactivate();
    _stompClient = null;
  }
}
