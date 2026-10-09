// author: juraj.suchan@gmail.com

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'draft_store.dart';

class SqliteDraftStore implements DraftStore {
  SqliteDraftStore({
    Future<Database> Function()? open,
    DateTime Function()? now,
    this.maxAge = const Duration(days: 30),
  }) : _open = open ?? _openDefault,
       _now = now ?? DateTime.now;

  static const table = 'drafts';

  final Future<Database> Function() _open;
  final DateTime Function() _now;
  final Duration maxAge;

  Future<Database>? _db;

  static Future<void> createSchema(Database db, int version) => db.execute(
    'CREATE TABLE $table ('
    'key TEXT PRIMARY KEY, '
    'text TEXT NOT NULL, '
    'updated_at INTEGER NOT NULL)',
  );

  static Future<Database> _openDefault() async => openDatabase(
    p.join(await getDatabasesPath(), 'nyxdroid.db'),
    version: 1,
    onCreate: createSchema,
  );

  Future<Database> get _database => _db ??= _openAndPrune();

  Future<Database> _openAndPrune() async {
    final db = await _open();
    final limit = _now().subtract(maxAge).millisecondsSinceEpoch;
    await db.delete(table, where: 'updated_at < ?', whereArgs: [limit]);
    return db;
  }

  @override
  Future<String?> load(String key) async {
    final db = await _database;
    final rows = await db.query(
      table,
      columns: ['text'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['text'] as String;
  }

  @override
  Future<void> save(String key, String text) async {
    final db = await _database;
    await db.insert(table, {
      'key': key,
      'text': text,
      'updated_at': _now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> delete(String key) async {
    final db = await _database;
    await db.delete(table, where: 'key = ?', whereArgs: [key]);
  }
}
