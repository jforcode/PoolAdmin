import 'package:pool_admin/models/game.dart';
import 'package:sqflite/sqflite.dart';

class GameDao {
  Database db;

  GameDao(this.db);

  static String getCreateDbStatement() {
    return '''
    CREATE TABLE GAME(
      id STRING PRIMARY KEY,
      start_time LONG,
      end_time LONG,
      num_players INTEGER,
      table_name STRING,
      price_per_hour INTEGER,
      ongoing BOOLEAN
    );
    ''';
  }

  Future<void> insert(Game game) async {
    await db.insert("GAME", game.toMap());
  }

  Future<void> updateOngoingToCreated({
    required String gameId,
    required int startTime,
    required int endTime,
  }) async {
    await db.update(
      "GAME",
      {
        'ongoing': 0,
        'end_time': endTime,
        'start_time': startTime,
      },
      where: 'id = ? and ongoing = ?',
      whereArgs: [gameId, 1],
    );
  }

  Future<Game?> getOngoingGameFor(String table) async {
    var ret =
        await db.query("GAME", where: 'table_name = ? and ongoing = ?', whereArgs: [table, 1]);
    if (ret.isEmpty) return null;

    return Game.fromMap(ret[0]);
  }

  Future<void> deleteOngoingGame(String gameId) async {
    await db.delete("GAME", where: 'id = ? and ongoing = ?', whereArgs: [gameId, 1]);
  }

  Future<List<Game>> getAll({bool all = false}) async {
    // get yesterday's last millisecond
    var today = DateTime.now();
    var yesterday = DateTime(today.year, today.month, today.day);

    String whereStr = all ? 'ongoing = ?' : 'ongoing = ? and end_time >= ?';
    List<Object?> whereArgs = all ? [0] : [0, yesterday.millisecondsSinceEpoch];

    var ret =
        await db.query("GAME", where: whereStr, whereArgs: whereArgs, orderBy: 'end_time DESC');
    return ret.map((e) => Game.fromMap(e)).toList();
  }
}
