import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class WalkDatabase {
  WalkDatabase._();

  static final WalkDatabase instance = WalkDatabase._();

  Future<Database>? _database;

  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async => openDatabase(
        path.join(await getDatabasesPath(), 'step_sync.db'),
        version: 1,
        onCreate: (db, _) async {
          await db.execute(
            'CREATE TABLE state (session TEXT PRIMARY KEY, value TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE lease (name TEXT PRIMARY KEY, owner TEXT NOT NULL, expires INTEGER NOT NULL)',
          );
        },
      );

  Future<T> exclusive<T>(String name, Future<T> Function() action) async {
    final timeout = Stopwatch()..start();
    String? owner;
    while (owner == null) {
      owner = await acquire(name);
      if (owner == null) {
        if (timeout.elapsed > const Duration(seconds: 25)) {
          throw StateError('동기화 작업 잠금을 기다리는 시간이 초과되었습니다.');
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }
    try {
      return await action();
    } finally {
      await release(name, owner);
    }
  }

  Future<Map<String, dynamic>> read(String session) async {
    final rows = await (await database).query(
      'state',
      where: 'session = ?',
      whereArgs: [session],
    );
    if (rows.isEmpty) return {};
    return jsonDecode(rows.single['value'] as String) as Map<String, dynamic>;
  }

  Future<void> save(String session, Map<String, dynamic> state) async {
    await (await database).insert(
        'state',
        {
          'session': session,
          'value': jsonEncode(state),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearExcept(String? session) async {
    final db = await database;
    if (session == null) {
      await db.delete('state');
    } else {
      await db.delete('state', where: 'session != ?', whereArgs: [session]);
    }
  }

  Future<String?> acquire(String name) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final owner = '$now-${Random.secure().nextInt(1 << 32)}';
    return (await database).transaction((txn) async {
      await txn.delete(
        'lease',
        where: 'name = ? AND expires <= ?',
        whereArgs: [name, now],
      );
      final rows = await txn.query(
        'lease',
        where: 'name = ?',
        whereArgs: [name],
      );
      if (rows.isNotEmpty) return null;
      await txn.insert('lease', {
        'name': name,
        'owner': owner,
        'expires': now + 120000,
      });
      return owner;
    });
  }

  Future<bool> owns(String name, String owner) async {
    final rows = await (await database).query(
      'lease',
      where: 'name = ? AND owner = ? AND expires > ?',
      whereArgs: [name, owner, DateTime.now().millisecondsSinceEpoch],
    );
    return rows.isNotEmpty;
  }

  Future<void> release(String name, String owner) async {
    await (await database).delete(
      'lease',
      where: 'name = ? AND owner = ?',
      whereArgs: [name, owner],
    );
  }
}
