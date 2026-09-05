import 'package:flutter/material.dart';

// [TODO] 탭 별 데이터 동기화를 위한 임시 클래스. 추후 삭제
class TabReloader {
  TabReloader._();

  static final _generations = <int, ValueNotifier<int>>{};

  static ValueNotifier<int> _notifierOf(int index) =>
      _generations.putIfAbsent(index, () => ValueNotifier(0));

  static void reload(int index) => _notifierOf(index).value++;

  static Widget wrap({required int index, required Widget child}) {
    return ValueListenableBuilder<int>(
      valueListenable: _notifierOf(index),
      builder: (_, generation, __) => KeyedSubtree(
        key: ValueKey('tab-$index-$generation'),
        child: child,
      ),
    );
  }
}
