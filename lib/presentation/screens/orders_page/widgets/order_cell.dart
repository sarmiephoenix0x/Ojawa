import 'package:flutter/material.dart';

class OrderCell extends StatelessWidget {
  final String text;
  final String? text2;
  final double width;
  final double? height;

  const OrderCell({
    super.key,
    required this.text,
    required this.width,
    this.text2,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (text2 != null)
            Text(
              text2!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.0,
                color: text == "Unpaid"
                    ? const Color(0xFFFF0000)
                    : text == "Partially paid" || text == "Paid"
                        ? const Color(0xFF008000)
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}
