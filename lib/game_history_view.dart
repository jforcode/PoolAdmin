import 'package:flutter/material.dart';

class GameHistoryView extends StatefulWidget {
  const GameHistoryView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GameHistoryViewState();
}

class GameHistoryViewState extends State<GameHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text('GameHistory'),
    );
  }
}
