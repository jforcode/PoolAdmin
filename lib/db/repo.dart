import 'package:path/path.dart';
import 'package:pool_admin/db/game_dao.dart';
import 'package:pool_admin/db/player_dao.dart';
import 'package:pool_admin/db/table_dao.dart';
import 'package:sqflite/sqflite.dart';

class Repo {
  static TableDao? _tableDao;
  static GameDao? _gameDao;
  static PlayerDao? _playerDao;

  static Future<bool> setup() async {
    try {
      final db = await openDatabase(
        join(await getDatabasesPath(), 'pool_admin.db'),
        onCreate: (db, version) => Future.wait([
          db.execute(TableDao.getCreateDbStatement()),
          db.execute(TableDao.getInitialDataStatement()),
          db.execute(GameDao.getCreateDbStatement()),
          db.execute(PlayerDao.getCreateDbStatement()),
        ]),
        version: 1,
      );

      _tableDao = TableDao(db);
      _gameDao = GameDao(db);
      _playerDao = PlayerDao(db);

      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  static TableDao getTableDao() {
    return _tableDao!;
  }

  static GameDao getGameDao() {
    return _gameDao!;
  }

  static PlayerDao getPlayerDao() {
    return _playerDao!;
  }
}
