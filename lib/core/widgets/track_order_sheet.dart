import 'package:flutter/material.dart';

import 'connecting_line.dart';
import 'custom_gap.dart';
import 'order_step.dart';

void trackOrder(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Track Order',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.02,
                      useMediaQuery: false),
                  const OrderStep(
                    timeStamp: "10:30 AM",
                    title: "Order Confirmed",
                    subText: "Your order has been confirmed",
                    isCompleted: true,
                  ),
                  const ConnectingLine(isCompleted: true),
                  const OrderStep(
                    timeStamp: "01:00 PM",
                    title: "Order Shipped",
                    subText: "Order shipped from [destination]",
                    isCompleted: true,
                  ),
                  const ConnectingLine(isCompleted: false),
                  const OrderStep(
                    timeStamp: "",
                    title: "Out for Delivery",
                    subText: "",
                    isCompleted: false,
                  ),
                  const ConnectingLine(isCompleted: false),
                  const OrderStep(
                    timeStamp: "",
                    title: "Order Delivered",
                    subText: "",
                    isCompleted: false,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
