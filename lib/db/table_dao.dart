import 'package:sqflite/sqflite.dart';

import '../models/table.dart';

class TableDao {
  final Database db;

  TableDao(this.db);

  static String getCreateDbStatement() {
    return '''
    CREATE TABLE MTABLE(
      id STRING PRIMARY KEY,
      name STRING,
      table_type INTEGER,
      price_per_hour INTEGER,
      active BOOLEAN
    );
    ''';
  }

  static String getInitialDataStatement() {
    return '''
    INSERT INTO MTABLE (id, name, table_type, price_per_hour, active)
    VALUES
    ('pool', 'POOL', 0, 150, true),
    ('french', 'FRENCH', 1, 200, true),
    ('english1', 'ENGLISH 1', 2, 250, true),
    ('english2', 'ENGLISH 2', 2, 250, true);
    ''';
  }

  Future<void> update(String tableId, String name, int newPrice) async {
    await db.update(
      "MTABLE",
      {"name": name, "price_per_hour": newPrice},
      where: "id = ?",
      whereArgs: [tableId],
    );
  }

  Future<List<MTable>> getAll() async {
    var ret = await db.query("MTABLE", where: "ACTIVE = ?", whereArgs: [1]);
    return ret.map((e) => MTable.fromMap(e)).toList();
  }

  Future<void> delete(String tableId) async {
    await db.update("MTABLE", {"active": 0}, where: "id = ?", whereArgs: [tableId]);
  }
}
