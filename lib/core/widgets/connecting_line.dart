import 'package:flutter/material.dart';

class ConnectingLine extends StatelessWidget {
  final bool isCompleted;

  const ConnectingLine({
    super.key,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 40, // Height of the line
          width: 2,
          color: isCompleted ? Colors.blue : Colors.grey,
          margin: const EdgeInsets.only(left: 74.0), // Align with ticks
        ));
  }
}
