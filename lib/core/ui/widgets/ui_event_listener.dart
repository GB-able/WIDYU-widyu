import 'dart:async';

import 'package:flutter/material.dart';

class UiEventListener<E> extends StatefulWidget {
  final Stream<E> stream;
  final void Function(E) onEvent;
  final Widget child;

  const UiEventListener({
    super.key,
    required this.stream,
    required this.onEvent,
    required this.child,
  });

  @override
  State<UiEventListener> createState() => _UiEventListenerState<E>();
}

class _UiEventListenerState<E> extends State<UiEventListener<E>> {
  late final StreamSubscription<E> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen((event) => widget.onEvent(event));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
