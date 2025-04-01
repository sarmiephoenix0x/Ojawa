import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';

class OrderCell extends StatelessWidget {
  final String text;
  final String? text2;
  final double width;
  final double? height;
  final bool isAmount;

  const OrderCell({
    super.key,
    required this.text,
    required this.width,
    this.text2,
    this.height,
    this.isAmount = false,
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
          if (isAmount) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'images/Naira.png',
                  height: 15,
                ),
                const Gap(2, isHorizontal: true),
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              text,
              softWrap: true,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
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
