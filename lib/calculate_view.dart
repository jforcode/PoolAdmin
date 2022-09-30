import 'package:flutter/material.dart';
import 'package:pool_admin/calculable_game_view.dart';
import 'package:pool_admin/db/repo.dart';

import 'models/game.dart';

class CalculateView extends StatefulWidget {
  const CalculateView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalculateViewState();
}

class CalculateViewState extends State<CalculateView> {
  List<Game> games = [];
  int totalCpp = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchGames();
    });
  }

  void fetchGames() async {
    games = await Repo.getGameDao().getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: games.length,
          itemBuilder: (context, pos) {
            return CalculableGameView(game: games[pos], onGameSelected: _select);
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total cost per person for these games:"),
                Text(
                  "\u20B9 $totalCpp",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _select(int cpp) {
    setState(() {
      totalCpp += cpp;
    });
  }
}
