import 'dart:async';
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
  final _connectionStateController = StreamController<bool>.broadcast();
  final _sensorResultController = StreamController<String>.broadcast();

  /// IMU 배치는 이 구독이 살아 있을 때만 보낼 수 있다(서버 요구). 심박·위치는 무관하다.
  StompUnsubscribe? _sensorResultUnsubscribe;

  String get _baseUrl => dotenv.env['BASE_URL'] ?? "";

  bool get _isConnected => _stompClient?.connected ?? false;

  static const String _socketPrefix = '/ws/location';
  static const String _locationDestination = '/app/location/update';
  static const String _heartRateDestination = '/app/heart-rate/send';
  static const String _sensorBatchDestination = '/app/sensor/batches/send';
  static const String _sensorResultDestination = '/user/queue/sensor/result';

  /// IMU 전송 가능 여부. 연결만이 아니라 [_sensorResultDestination] 구독까지 끝나야 true 가 된다.
  Stream<bool> get connectionState => _connectionStateController.stream;

  /// 서버가 [_sensorResultDestination] 로 내려주는 메시지 원문. 형식 미확정이라 그대로 흘린다.
  Stream<String> get sensorResults => _sensorResultController.stream;

  bool get _isSensorSubscribed => _sensorResultUnsubscribe != null;

  void connect(String token) {
    if (_stompClient != null) return;

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$_baseUrl$_socketPrefix?token=$token',
        onConnect: (StompFrame frame) {
          log('Socket connected.');
          _subscribeSensorResult();
          _connectionStateController.add(true);
        },
        onWebSocketError: (dynamic error) {
          log('WebSocket Error: ${error.toString()}');
          _onLost();
        },
        onStompError: (StompFrame frame) {
          log('STOMP Error: ${frame.body}');
          _onLost();
        },
        onDisconnect: (StompFrame frame) => _onLost(),
        onWebSocketDone: _onLost,
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

  bool sendSensorBatch(Map<String, dynamic> json) {
    if (!_isSensorSubscribed) {
      log('Sensor result not subscribed yet, cannot send sensor batch.');
      return false;
    }
    return _send(
      _sensorBatchDestination,
      json,
      'sensor batch',
    );
  }

  void _subscribeSensorResult() {
    final client = _stompClient;
    if (client == null || _isSensorSubscribed) return;
    _sensorResultUnsubscribe = client.subscribe(
      destination: _sensorResultDestination,
      callback: (StompFrame frame) {
        final body = frame.body;
        if (body == null) return;
        log('Sensor result: $body');
        _sensorResultController.add(body);
      },
    );
  }

  /// 연결이 끊기면 서버 쪽 구독도 함께 사라지므로 재연결 시 다시 구독한다.
  void _onLost() {
    _sensorResultUnsubscribe = null;
    _connectionStateController.add(false);
  }

  bool _send(
    String destination,
    Map<String, dynamic> json,
    String label,
  ) {
    if (!_isConnected) {
      log("Socket Client is not connected, cannot send $label.");
      return false;
    }

    try {
      final body = jsonEncode(json);
      _stompClient!.send(destination: destination, body: body);
      return true;
    } catch (e) {
      log("Failed to send $label: $e");
      return false;
    }
  }

  void disconnect() {
    _sensorResultUnsubscribe?.call();
    _stompClient?.deactivate();
    _stompClient = null;
    _onLost();
  }
}
