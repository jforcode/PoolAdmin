import 'package:flutter/material.dart';
import 'package:pool_admin/db/repo.dart';
import 'package:pool_admin/models/game.dart';
import 'package:pool_admin/models/table.dart';

import 'game_view.dart';

class TableView extends StatefulWidget {
  const TableView({Key? key, required this.table}) : super(key: key);

  final MTable table;

  @override
  State<StatefulWidget> createState() => TableViewState();
}

enum UIGameState { na, ongoing, needConfirmation }

class TableViewState extends State<TableView> {
  final int maxPlayers = 6;
  UIGameState state = UIGameState.na;
  Game? ongoingGame;
  int numPlayers = 2;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    var game = await Repo.getGameDao().getOngoingGameFor(widget.table.name);
    setState(() {
      ongoingGame = game;
      state = ongoingGame == null ? UIGameState.na : UIGameState.ongoing;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    switch (state) {
      case UIGameState.na:
        child = _getInitialWidget();
        break;
      case UIGameState.ongoing:
        child = _getOngoingWidget();
        break;
      case UIGameState.needConfirmation:
        child = _getGameView();
        break;
    }

    return Card(
      child: Container(
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }

  Widget _getInitialWidget() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: _getTableNameWidget(),
        ),
        Align(
          alignment: Alignment.center,
          child: Slider(
            value: numPlayers.toDouble(),
            onChanged: (value) {
              setState(() {
                numPlayers = value.round();
              });
            },
            max: maxPlayers.toDouble(),
            min: 1,
            label: "$numPlayers",
            divisions: maxPlayers - 1,
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Text("$numPlayers players"),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: _onCreatePressed,
            child: Text("START ${widget.table.name.toUpperCase()} GAME"),
          ),
        )
      ],
    );
  }

  Widget _getOngoingWidget() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getTableNameWidget(),
              Text("$numPlayers players"),
              Text(ongoingGame!.startTimeDisplay()),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _cancelOngoingGame,
            icon: const Icon(Icons.cancel),
            color: Colors.grey.shade500,
            iconSize: 36,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: _closeGame,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey.shade500),
            ),
            child: const Text("CLOSE GAME"),
          ),
        ),
      ],
    );
  }

  Widget _getTableNameWidget() {
    return Text(
      widget.table.name.toUpperCase(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _getGameView() {
    return Stack(
      children: [
        Align(alignment: Alignment.topCenter, child: GameView(game: ongoingGame!, editable: true)),
        Align(
          alignment: Alignment.bottomLeft,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _cancelGameSave,
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            iconSize: 36,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _saveGame,
            icon: const Icon(Icons.check_circle),
            color: Colors.green,
            iconSize: 36,
          ),
        ),
      ],
    );
  }

  void _onCreatePressed() async {
    var now = DateTime.now();
    var startTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    var game = Game(
      gameId: "Game_${now.millisecondsSinceEpoch}",
      tableName: widget.table.name,
      numPlayers: numPlayers,
      startTime: startTime.millisecondsSinceEpoch,
    );
    game.pricePerHour = widget.table.pricePerHour;
    game.ongoing = true;

    await Repo.getGameDao().insert(game);

    setState(() {
      state = UIGameState.ongoing;
      ongoingGame = game;
    });
  }

  void _closeGame() async {
    ongoingGame!.endTime = DateTime.now().millisecondsSinceEpoch;

    setState(() {
      state = UIGameState.needConfirmation;
    });
  }

  void _cancelOngoingGame() async {
    await Repo.getGameDao().deleteOngoingGame(ongoingGame!.gameId);

    setState(() {
      state = UIGameState.na;
      ongoingGame = null;
    });
  }

  void _cancelGameSave() {
    setState(() {
      state = UIGameState.ongoing;
    });
  }

  void _saveGame() async {
    if (ongoingGame!.getDuration().inMinutes < 5) {
      var message = "The game should be at least 5 minutes in duration";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    await Repo.getGameDao().updateOngoingToCreated(
      gameId: ongoingGame!.gameId,
      startTime: ongoingGame!.startTime,
      endTime: ongoingGame!.endTime,
    );

    if (!mounted) return;
    var message = "Game created.";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

    setState(() {
      state = UIGameState.na;
      ongoingGame = null;
      numPlayers = 2;
    });
  }
}
