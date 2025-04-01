import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_gap.dart';
import '../../../../core/widgets/custom_attribute.dart';

class HistoryCards extends StatelessWidget {
  final String id;
  final String date;
  final String paymentAddress;
  final String paymentType;
  final String paymentStatus;
  final String remark;
  final int amount;

  const HistoryCards({
    super.key,
    required this.id,
    required this.date,
    required this.paymentAddress,
    required this.paymentType,
    required this.paymentStatus,
    required this.remark,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    "ID: $id",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: paymentStatus == "Approved"
                          ? const Color.fromARGB(117, 0, 128, 0)
                          : paymentStatus == "Pending"
                              ? const Color.fromARGB(110, 0, 0, 255)
                              : paymentStatus == "Declined"
                                  ? const Color.fromARGB(122, 255, 255, 0)
                                  : null,
                      borderRadius: BorderRadius.circular(8),
                      border: paymentStatus == "Approved"
                          ? Border.all(width: 1, color: const Color(0xFF008000))
                          : paymentStatus == "Pending"
                              ? Border.all(
                                  width: 1, color: const Color(0xFF0000FF))
                              : paymentStatus == "Declined"
                                  ? Border.all(
                                      width: 1, color: const Color(0xFFFFFF00))
                                  : null,
                    ),
                    child: Text(
                      paymentStatus,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                        color: paymentStatus == "Approved"
                            ? const Color(0xFF008000)
                            : paymentStatus == "Pending"
                                ? const Color(0xFF0000FF)
                                : paymentStatus == "Declined"
                                    ? const Color(0xFFFFFF00)
                                    : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            CustomAttribute(
              text: 'Date',
              text2: date,
              fontWeightTxt2: FontWeight.bold,
            ),
            CustomAttribute(
              text: 'Payment Address',
              text2: paymentAddress,
              fontWeightTxt2: FontWeight.bold,
            ),
            CustomAttribute(
              text: 'Payment Type',
              text2: paymentType,
              fontWeightTxt2: FontWeight.bold,
            ),
            CustomAttribute(
              text: 'Remark',
              text2: remark,
              fontWeightTxt2: FontWeight.bold,
            ),
            const Gap(30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    "Amount",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/Naira.png',
                        height: 15,
                      ),
                      const Gap(2, isHorizontal: true),
                      Text(
                        amount.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
