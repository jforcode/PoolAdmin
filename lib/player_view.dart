import 'package:flutter/material.dart';
import 'package:pool_admin/db/repo.dart';

import 'models/player.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({Key? key, required this.player}) : super(key: key);

  final Player player;

  @override
  State<StatefulWidget> createState() => PlayerViewState();
}

class PlayerViewState extends State<PlayerView> {
  bool playerIsPaying = true;
  bool showingSettlementUI = false;
  TextEditingController ctrl = TextEditingController(text: "0");

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String amountStr = "\u20B9${(widget.player.amountPlayerOwes).abs()}";
    String nameStr = "${widget.player.name} (${widget.player.phone})";
    String display = widget.player.amountPlayerOwes == 0
        ? "You and ${widget.player.name} are settled"
        : widget.player.amountPlayerOwes < 0
            ? "You owe $nameStr $amountStr"
            : "$nameStr owes you $amountStr";

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(display, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                widget.player.amountPlayerOwes == 0
                    ? Container()
                    : Icon(
                        Icons.swap_vert_circle,
                        color: widget.player.amountPlayerOwes >= 0 ? Colors.green : Colors.red,
                      ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () => setState(() => showingSettlementUI = !showingSettlementUI),
                child: Text(showingSettlementUI ? "HIDE SETTLEMENT UI" : "SHOW SETTLEMENT UI"),
              ),
            ),
            showingSettlementUI ? _getSettlementWidget() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _getSettlementWidget() {
    int postSettlementAmount =
        widget.player.amountPlayerOwes - (ctrl.text.isEmpty ? 0 : (int.tryParse(ctrl.text) ?? 0));
    String settlementStr = "";
    if (postSettlementAmount == 0) {
      settlementStr = "Final: You and ${widget.player.name} are settled!";
    } else if (postSettlementAmount < 0) {
      settlementStr = "Final: You will owe ${widget.player.name} ${-postSettlementAmount}";
    } else {
      settlementStr = "Final: ${widget.player.name} will owe you $postSettlementAmount";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Player is paying?"),
            Checkbox(
              value: playerIsPaying,
              onChanged: (value) => setState(() => playerIsPaying = !playerIsPaying),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: 92,
              child: TextField(
                controller: ctrl,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  prefixText: "\u20B9",
                  hintText: "Amount",
                  hintStyle: TextStyle(fontSize: 14),
                ),
                onChanged: (val) => setState(() => {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(settlementStr, style: const TextStyle(fontWeight: FontWeight.bold)),
            postSettlementAmount != widget.player.amountPlayerOwes
                ? ElevatedButton(onPressed: _confirmSettleUp, child: const Text("CONFIRM"))
                : Container(),
          ],
        )
      ],
    );
  }

  void _confirmSettleUp() {
    int postSettlementAmount =
        widget.player.amountPlayerOwes - (ctrl.text.isEmpty ? 0 : (int.tryParse(ctrl.text) ?? 0));
    Repo.getPlayerDao().update(widget.player.id, postSettlementAmount);
    widget.player.amountPlayerOwes = postSettlementAmount;

    setState(() {
      ctrl.text = "0";
      showingSettlementUI = false;
      playerIsPaying = true;
    });
  }
}
