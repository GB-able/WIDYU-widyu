import 'dart:async';

import 'package:flutter/material.dart';

/// 화면이 숨은 동안(비활성 탭처럼 TickerMode가 꺼진 동안) 들어온 이벤트는 모아 두었다가
/// 다시 보일 때 실행한다. [runWhileInactive]가 true인 이벤트는 숨은 동안에도 바로 실행한다.
class UiEventListener<E> extends StatefulWidget {
  final Stream<E> stream;
  final void Function(E) onEvent;
  final bool Function(E)? runWhileInactive;
  final Widget child;

  const UiEventListener({
    super.key,
    required this.stream,
    required this.onEvent,
    this.runWhileInactive,
    required this.child,
  });

  @override
  State<UiEventListener<E>> createState() => _UiEventListenerState<E>();
}

class _UiEventListenerState<E> extends State<UiEventListener<E>> {
  late final StreamSubscription<E> _subscription;
  final _pending = <E>[];
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(_handle);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isActive = TickerMode.of(context);
    if (_isActive && _pending.isNotEmpty) {
      // build 중에 다이얼로그·화면 이동을 실행하지 않도록 프레임 뒤로 미룬다.
      WidgetsBinding.instance.addPostFrameCallback((_) => _flush());
    }
  }

  void _handle(E event) {
    if (_isActive || (widget.runWhileInactive?.call(event) ?? false)) {
      widget.onEvent(event);
    } else {
      _pending.add(event);
    }
  }

  void _flush() {
    if (!mounted || !_isActive) return;
    final events = [..._pending];
    _pending.clear();
    events.forEach(widget.onEvent);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
