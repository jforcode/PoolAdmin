import 'package:flutter/material.dart';
import 'package:pool_admin/db/repo.dart';
import 'package:pool_admin/player_view.dart';
import 'package:pool_admin/util.dart';

import 'models/player.dart';

class PendingAmountView extends StatefulWidget {
  const PendingAmountView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PendingAmountViewState();
}

class PendingAmountViewState extends State<PendingAmountView> {
  var getAll = Repo.getPlayerDao().getAll();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAll,
      initialData: const <Player>[],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        var players = snapshot.data! as List<Player>;

        return Stack(
          children: [
            ListView.builder(
              itemCount: players.length + 1,
              itemBuilder: (context, pos) {
                if (pos == players.length) {
                  return const SizedBox(height: 120);
                }
                return PlayerView(player: players[pos]);
              },
              padding: const EdgeInsets.all(12),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => Navigator.of(context).pushNamed(Util.routeNewPending).then((_) {
                  setState(() {
                    getAll = Repo.getPlayerDao().getAll();
                  });
                }),
              ),
            )
          ],
        );
      },
    );
  }
}
