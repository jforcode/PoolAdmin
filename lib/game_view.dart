import 'package:flutter/material.dart';

import 'models/game.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key, required this.game, this.editable = false}) : super(key: key);

  final Game game;
  final bool editable;

  @override
  State<StatefulWidget> createState() => GameViewState();
}

class GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    var durationString = _getDurationString(widget.game.getDuration());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.game.tableName}\n\u20B9 ${widget.game.pricePerHour} / hour",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            getDateWidget(),
            Text(durationString),
          ],
        ),
        Container(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("\u20B9 ${widget.game.totalCost().toStringAsFixed(2)}"),
            Text("${widget.game.numPlayers} players"),
            Text("\u20B9 ${widget.game.costPerPerson().toStringAsFixed(2)}"),
          ],
        )
      ],
    );
  }

  Widget getDateWidget() {
    var startTime = widget.game.startTimeDisplay();
    var endTime = widget.game.endTimeDisplay();

    if (widget.editable) {
      return Row(
        children: [
          TextButton(onPressed: _updateStartTime, child: Text(startTime)),
          const Text("-"),
          TextButton(onPressed: _updateEndTime, child: Text(endTime)),
        ],
      );
    }

    return Text("$startTime - $endTime");
  }

  String _getDurationString(Duration duration) {
    var durationString = "";
    if (duration.inHours > 0) {
      durationString = "${duration.inHours} hrs";
    }

    var minutes = duration.inMinutes - duration.inHours * 60;
    if (minutes > 0) {
      durationString = "$durationString $minutes mins";
    }

    return durationString;
  }

  void _updateStartTime() async {
    var selected = await getUpdatedTime(DateTime.fromMillisecondsSinceEpoch(widget.game.startTime));
    setState(() {
      widget.game.startTime = selected.millisecondsSinceEpoch;
    });
  }

  void _updateEndTime() async {
    var selected = await getUpdatedTime(DateTime.fromMillisecondsSinceEpoch(widget.game.endTime));

    setState(() {
      widget.game.endTime = selected.millisecondsSinceEpoch;
    });
  }

  Future<DateTime> getUpdatedTime(DateTime date) async {
    var s = TimeOfDay(hour: date.hour, minute: date.minute);

    final TimeOfDay? pickedS = await showTimePicker(
      context: context,
      initialTime: s,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedS != null && pickedS != s) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        pickedS.hour,
        pickedS.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    }

    return date;
  }
}
