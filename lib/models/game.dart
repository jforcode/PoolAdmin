// can create a system where no tables are ever deleted/updated
// every update/delete creates a new record, and this game links to the previous record in db
// for now, this duplication is fine
class Game {
  String gameId;
  int startTime;
  int numPlayers;
  final String tableName;
  int pricePerHour = 0;
  int endTime = 0;
  bool ongoing = false;

  Game({
    required this.gameId,
    required this.startTime,
    required this.numPlayers,
    required this.tableName,
  });

  Game.fromMap(Map<String, Object?> map)
      : gameId = map['id'] as String,
        startTime = map['start_time'] as int,
        numPlayers = map['num_players'] as int,
        tableName = map['table_name'] as String,
        pricePerHour = map['price_per_hour'] as int,
        endTime = map['end_time'] as int,
        ongoing = (map['ongoing'] as int) == 1;

  Map<String, Object?> toMap() {
    return {
      'id': gameId,
      'start_time': startTime,
      'num_players': numPlayers,
      'table_name': tableName,
      'price_per_hour': pricePerHour,
      'end_time': endTime,
      'ongoing': ongoing ? 1 : 0,
    };
  }

  Duration getDuration() {
    return Duration(milliseconds: endTime - startTime);
  }

  int totalCost() {
    return (pricePerHour / 60 * getDuration().inMinutes).ceil();
  }

  int costPerPerson() {
    return (totalCost() / numPlayers).ceil();
  }

  String startTimeDisplay() => _getTimeString(startTime);

  String endTimeDisplay() => _getTimeString(endTime);

  String _getTimeString(int mis) {
    var date = DateTime.fromMillisecondsSinceEpoch(mis);

    String period = "AM";
    var hour = date.hour;
    if (hour >= 12) {
      period = "PM";
      if (hour > 12) hour -= 12;
    }

    var minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";

    return "$hour:$minute $period";
  }
}
