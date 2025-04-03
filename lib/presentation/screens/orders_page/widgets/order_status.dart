import 'package:flutter/material.dart';

class OrderStatus extends StatelessWidget {
  final String text;
  final String text2;
  final double width;
  final double? height;

  const OrderStatus({
    super.key,
    required this.text,
    required this.text2,
    required this.width,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: text == "Pending"
                  ? const Color.fromARGB(110, 0, 0, 255)
                  : text == "Out For Delivery"
                      ? const Color.fromARGB(120, 255, 166, 0)
                      : const Color.fromARGB(122, 0, 128, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.0,
                color: text == "Pending"
                    ? const Color(0xFF0000FF)
                    : text == "Out For Delivery"
                        ? const Color(0xFFFFA500)
                        : const Color(0xFF008000),
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
