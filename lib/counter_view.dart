import 'package:flutter/material.dart';

class CounterView extends StatefulWidget {
  const CounterView({
    Key? key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.ctrl,
  }) : super(key: key);

  final int minValue;
  final int maxValue;
  final CounterController ctrl;

  @override
  State<StatefulWidget> createState() => CounterViewState();
}

class CounterViewState extends State<CounterView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (widget.ctrl.value == widget.minValue) return;
              widget.ctrl.value++;
            });
          },
          icon: const Icon(Icons.remove),
        ),
        Text("${widget.ctrl.value}"),
        IconButton(
          onPressed: () {
            setState(() {
              if (widget.ctrl.value == widget.maxValue) return;
              widget.ctrl.value++;
            });
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}

class CounterController extends ValueNotifier<int> {
  CounterController(int initial) : super(initial);

  int getValue() {
    return value;
  }
}
