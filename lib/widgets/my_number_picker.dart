import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class MyNumberPicker extends StatefulWidget {
  const MyNumberPicker(
      {super.key, required this.firstValue, required this.limitValue});

  final int firstValue;
  final int limitValue;

  @override
  State<MyNumberPicker> createState() => _MyNumberPickerState();
}

class _MyNumberPickerState extends State<MyNumberPicker> {
  int _startingValue = 0;
  int min = 0;
  int max = 100;

  @override
  void initState() {
    super.initState();
    _startingValue = widget.firstValue;
    if (_startingValue < widget.limitValue) {
      max = widget.limitValue - 1;
    } else {
      min = widget.limitValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NumberPicker(
            minValue: min,
            maxValue: max,
            value: _startingValue,
            onChanged: ((value) => setState(() => _startingValue = value))),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _startingValue);
            },
            child: const Text("Ok"))
      ],
    );
  }
}
