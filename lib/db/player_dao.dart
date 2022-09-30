import 'package:sqflite/sqflite.dart';

import '../models/player.dart';

class PlayerDao {
  Database db;

  PlayerDao(this.db);

  static String getCreateDbStatement() {
    return '''
    CREATE TABLE PLAYER(
      id STRING PRIMARY KEY,
      name STRING,
      phone STRING,
      amount_player_owes INTEGER
    );
    ''';
  }

  static String getInitialCreateStatement() {
    return '';
  }

  Future<bool> exists(String name) async {
    var snap = await db.query(
      "PLAYER",
      columns: ["COUNT(*) as count"],
      where: "name = ?",
      whereArgs: [name.trim()],
    );

    var count = snap[0]['count'] as int;
    return count > 0;
  }

  Future<void> insert(Player player) async {
    await db.insert("PLAYER", player.toMap());
  }

  Future<void> update(String playerId, int amount) async {
    await db.update(
      "PLAYER",
      {'amount_player_owes': amount},
      where: 'id = ?',
      whereArgs: [playerId],
    );
  }

  Future<List<Player>> getAll() async {
    var ret = await db.query("PLAYER", orderBy: 'name');

    return ret.map((e) => Player.fromMap(e)).toList();
  }
}
