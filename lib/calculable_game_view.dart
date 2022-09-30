import 'package:flutter/material.dart';

import 'game_view.dart';
import 'models/game.dart';

class CalculableGameView extends StatefulWidget {
  const CalculableGameView({
    Key? key,
    required this.game,
    required this.onGameSelected,
  }) : super(key: key);

  final Game game;
  final Function(int) onGameSelected;

  @override
  State<StatefulWidget> createState() => CalculableGameViewState();
}

class CalculableGameViewState extends State<CalculableGameView> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _onSelected,
        child: Container(
          color: selected ? Colors.blueGrey : Colors.white,
          padding: const EdgeInsets.all(12),
          child: GameView(game: widget.game),
        ),
      ),
    );
  }

  void _onSelected() {
    // do view changes, like showing a check or something
    // send the per person cost for this game to the caller
    selected = !selected;
    var cpp = widget.game.costPerPerson();
    widget.onGameSelected(selected ? cpp : -cpp);
  }
}
