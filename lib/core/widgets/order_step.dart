import 'package:flutter/material.dart';

import 'custom_gap.dart';

class OrderStep extends StatelessWidget {
  final String timeStamp;
  final String title;
  final String subText;
  final bool isCompleted;

  const OrderStep({
    super.key,
    required this.timeStamp,
    required this.title,
    required this.subText,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column for vertical alignment
          if (timeStamp.isNotEmpty) ...[
            Text(
              timeStamp,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ] else ...[
            Gap(MediaQuery.of(context).size.width * 0.145,
                isHorizontal: true, useMediaQuery: false),
          ],
          Gap(MediaQuery.of(context).size.width * 0.03,
              isHorizontal: true, useMediaQuery: false),

          Icon(
            Icons.check_circle,
            color: isCompleted ? Colors.blue : Colors.grey,
            size: 24,
          ),

          Gap(MediaQuery.of(context).size.width * 0.03,
              isHorizontal: true, useMediaQuery: false),
          // Title and subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: isCompleted ? Colors.black : Colors.grey,
                  ),
                ),
                if (subText.isNotEmpty) ...[
                  const Gap(4.0),
                  Text(
                    subText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
