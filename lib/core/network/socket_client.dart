import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:widyu/core/log/log.dart';

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

  String get _baseUrl => dotenv.env['BASE_URL'] ?? '';

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
        WiduLog.socket.w('소켓 토큰 발급 실패');
        _scheduleReconnect();
        return;
      }
      // 재연결하며 정리한 옛 클라이언트의 콜백이 늦게 와도 새 연결을 끊지 않도록, 현재 클라이언트의 것만 처리한다.
      late final StompClient client;
      bool isCurrent() => identical(_stompClient, client);
      client = StompClient(
        config: StompConfig.sockJS(
          url: '$_baseUrl$_socketPrefix?token=$token',
          reconnectDelay: Duration.zero,
          onConnect: (StompFrame frame) {
            if (!isCurrent()) return;
            WiduLog.socket.i('연결됨');
            _reconnectDelay = _initialReconnectDelay;
            _subscribeSensorResult();
            _subscribeErrors();
            _connectionStateController.add(true);
          },
          onWebSocketError: (dynamic error) {
            if (!isCurrent()) return;
            // 에러 문자열에 토큰이 담긴 소켓 URL이 섞일 수 있어 타입만 남긴다.
            _onLost('websocket error: ${error.runtimeType}');
          },
          onStompError: (StompFrame frame) {
            if (!isCurrent()) return;
            // 서버가 ERROR 프레임을 보내면 연결을 끊는다. 본문에 요청 값이 섞일 수 있어 trace로만 싣는다.
            WiduLog.socket.t(() =>
                'ERROR 프레임: ${frame.headers['message']} ${frame.body}');
            _onLost('stomp error');
          },
          onDisconnect: (StompFrame frame) {
            if (isCurrent()) _onLost('disconnected');
          },
          onWebSocketDone: () {
            if (isCurrent()) _onLost('websocket closed');
          },
          onDebugMessage: kDebugMode ? _logStompFrame : (_) {},
        ),
      );
      _stompClient = client;
      client.activate();
    } finally {
      _activating = false;
    }
  }

  void _scheduleReconnect() {
    if (!_wantConnection || _reconnectTimer != null) return;
    final delay = _reconnectDelay;
    WiduLog.socket.i('${delay.inSeconds}초 후 재연결');
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      // 현재 클라이언트에서 먼저 떼어 낸 뒤 정리해야 그 정리에서 나온 콜백이 무시된다.
      final old = _stompClient;
      _stompClient = null;
      old?.deactivate();
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
      WiduLog.socket.d('센서 결과 구독 전이라 센서 배치 전송 생략');
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
        WiduLog.socket.d('센서 결과 수신');
        WiduLog.socket.t(() => '센서 결과 본문: $body');
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
        WiduLog.socket.w('서버 거부 메시지 수신');
        WiduLog.socket.t(() => '서버 거부 본문: ${frame.body}');
      },
    );
  }

  /// 연결이 끊기면 서버 쪽 구독도 함께 사라지므로 재연결 시 다시 구독한다.
  void _onLost([String? reason]) {
    if (reason != null) WiduLog.socket.i('연결 끊김: $reason');
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
      WiduLog.socket.d('미연결 상태라 $label 전송 생략');
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
    } catch (e, stack) {
      WiduLog.socket.w('$label 전송 실패', error: e, stackTrace: stack);
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
    final old = _stompClient;
    _stompClient = null;
    old?.deactivate();
    _onLost();
  }

  /// 끊김 원인 추적용(디버그 전용). 매초 나가는 배치 SEND 프레임은 너무 많아 머리만 남긴다.
  static void _logStompFrame(String frame) {
    final line = frame.replaceAll('\n', ' ');
    final isSend = line.startsWith('>>> SEND');
    WiduLog.socket.t(line.length > 200 || isSend
        ? '${line.substring(0, line.length < 120 ? line.length : 120)}…'
        : line);
  }
}
