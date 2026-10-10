import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketClient {
  static final SocketClient _instance = SocketClient._internal();

  factory SocketClient() => _instance;

  SocketClient._internal();

  StompClient? _stompClient;

  /// 재연결마다 새 WS 토큰을 받아야 하므로(30초·일회용) 토큰 자체가 아니라 발급자를 들고 있는다.
  Future<String?> Function()? _tokenProvider;
  Timer? _reconnectTimer;
  Duration _reconnectDelay = _initialReconnectDelay;
  bool _wantConnection = false;
  bool _activating = false;
  final _connectionStateController = StreamController<bool>.broadcast();
  final _sensorResultController = StreamController<String>.broadcast();

  /// IMU 배치는 이 구독이 살아 있을 때만 보낼 수 있다(서버 요구). 심박·위치는 무관하다.
  StompUnsubscribe? _sensorResultUnsubscribe;

  /// 서버가 거부한 요청의 사유가 내려오는 구독.
  StompUnsubscribe? _errorUnsubscribe;

  String get _baseUrl => dotenv.env['BASE_URL'] ?? "";

  bool get _isConnected => _stompClient?.connected ?? false;

  static const String _socketPrefix = '/ws/location';
  static const String _locationDestination = '/app/location/update';
  static const String _sensorBatchDestination = '/app/sensor/batches/send';
  static const String _sensorResultDestination = '/user/queue/sensor/result';
  static const String _errorDestination = '/user/queue/errors';
  static const Duration _initialReconnectDelay = Duration(seconds: 5);
  static const Duration _maxReconnectDelay = Duration(seconds: 60);

  /// IMU 전송 가능 여부. 연결만이 아니라 [_sensorResultDestination] 구독까지 끝나야 true 가 된다.
  Stream<bool> get connectionState => _connectionStateController.stream;

  /// 서버가 [_sensorResultDestination] 로 내려주는 메시지 원문. 형식 미확정이라 그대로 흘린다.
  Stream<String> get sensorResults => _sensorResultController.stream;

  bool get _isSensorSubscribed => _sensorResultUnsubscribe != null;

  /// WS 토큰이 30초·일회용이라 StompConfig 자동 재연결을 끄고 [tokenProvider] 로 새 토큰을 받아 직접 다시 붙는다.
  Future<void> connect({
    required Future<String?> Function() tokenProvider,
  }) async {
    _tokenProvider = tokenProvider;
    if (_stompClient != null || _activating) return;
    _wantConnection = true;
    await _activate();
  }

  Future<void> _activate() async {
    final provider = _tokenProvider;
    if (provider == null || !_wantConnection || _activating) return;
    _activating = true;
    try {
      final token = await provider();
      if (!_wantConnection) return;
      if (token == null) {
        log('Socket token issue failed.');
        _scheduleReconnect();
        return;
      }
      _stompClient = StompClient(
        config: StompConfig.sockJS(
          url: '$_baseUrl$_socketPrefix?token=$token',
          reconnectDelay: Duration.zero,
          onConnect: (StompFrame frame) {
            log('Socket connected.');
            _reconnectDelay = _initialReconnectDelay;
            _subscribeSensorResult();
            _subscribeErrors();
            _connectionStateController.add(true);
          },
          onWebSocketError: (dynamic error) {
            log('WebSocket Error: ${error.toString()}');
            _onLost();
          },
          onStompError: (StompFrame frame) {
            if (kDebugMode) log('STOMP Error: ${frame.body}');
            _onLost();
          },
          onDisconnect: (StompFrame frame) => _onLost(),
          onWebSocketDone: _onLost,
        ),
      );
      _stompClient!.activate();
    } finally {
      _activating = false;
    }
  }

  void _scheduleReconnect() {
    if (!_wantConnection || _reconnectTimer != null) return;
    final delay = _reconnectDelay;
    log('Socket reconnect in ${delay.inSeconds}s.');
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      _stompClient?.deactivate();
      _stompClient = null;
      _activate();
    });
    final next = delay * 2;
    _reconnectDelay = next > _maxReconnectDelay ? _maxReconnectDelay : next;
  }

  bool sendLocation(Map<String, dynamic> json) => _send(
        _locationDestination,
        json,
        'location',
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
        log('Sensor result received.');
        if (kDebugMode) log('Sensor result body: $body');
        _sensorResultController.add(body);
      },
    );
  }

  /// 서버가 요청을 거부한 사유. 본문에 위치·식별자가 섞일 수 있어 디버그에서만 찍는다.
  void _subscribeErrors() {
    final client = _stompClient;
    if (client == null || _errorUnsubscribe != null) return;
    _errorUnsubscribe = client.subscribe(
      destination: _errorDestination,
      callback: (StompFrame frame) {
        log('Socket error message received');
        if (kDebugMode) log('Socket error body: ${frame.body}');
      },
    );
  }

  /// 연결이 끊기면 서버 쪽 구독도 함께 사라지므로 재연결 시 다시 구독한다.
  void _onLost() {
    _sensorResultUnsubscribe = null;
    _errorUnsubscribe = null;
    _connectionStateController.add(false);
    _scheduleReconnect();
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
      _stompClient!.send(
        destination: destination,
        headers: const {'content-type': 'application/json'},
        body: body,
      );
      return true;
    } catch (e) {
      log("Failed to send $label: $e");
      return false;
    }
  }

  void disconnect() {
    _wantConnection = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectDelay = _initialReconnectDelay;
    _sensorResultUnsubscribe?.call();
    _errorUnsubscribe?.call();
    _stompClient?.deactivate();
    _stompClient = null;
    _onLost();
  }
}
