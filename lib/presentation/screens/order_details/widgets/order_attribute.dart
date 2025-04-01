import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';

class OrderAttribute extends StatelessWidget {
  final String text;
  final String text2;
  final bool isAmount;

  const OrderAttribute({
    super.key,
    required this.text,
    required this.text2,
    this.isAmount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$text: ',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
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
                  text2,
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
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: text2 == "Unpaid" || text2 == "No"
                    ? const Color.fromARGB(113, 255, 0, 0)
                    : text2 == "Partially paid" ||
                            text2 == "Paid" ||
                            text2 == "Delivery" ||
                            text2 == "Delivered" ||
                            text2 == "Confirmed"
                        ? const Color.fromARGB(117, 0, 128, 0)
                        : text2 == "Pending"
                            ? const Color.fromARGB(122, 255, 255, 0)
                            : null,
                borderRadius: BorderRadius.circular(8),
                border: text2 == "Unpaid" || text2 == "No"
                    ? Border.all(width: 1, color: const Color(0xFFFF0000))
                    : text2 == "Partially paid" ||
                            text2 == "Paid" ||
                            text2 == "Delivery" ||
                            text2 == "Delivered" ||
                            text2 == "Confirmed"
                        ? Border.all(
                            width: 1,
                            color: const Color.fromARGB(117, 0, 128, 0))
                        : text2 == "Pending"
                            ? Border.all(
                                width: 1, color: const Color(0xFFFFFF00))
                            : null,
              ),
              child: Text(
                text2,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  color: text2 == "Unpaid" || text2 == "No"
                      ? const Color(0xFFFF0000)
                      : text2 == "Partially paid" ||
                              text2 == "Paid" ||
                              text2 == "Delivery" ||
                              text2 == "Delivered" ||
                              text2 == "Confirmed"
                          ? const Color.fromARGB(117, 0, 128, 0)
                          : text2 == "Pending"
                              ? Colors.black
                              : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
