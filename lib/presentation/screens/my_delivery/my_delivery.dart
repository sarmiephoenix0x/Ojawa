import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_bg.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_filter.dart';
import '../../../core/widgets/custom_gap.dart';
import '../wallet_history/widgets/history_cards.dart';
import 'widgets/delivery_cards.dart';

class MyDelivery extends StatefulWidget {
  const MyDelivery({super.key});

  @override
  _MyDeliveryState createState() => _MyDeliveryState();
}

class _MyDeliveryState extends State<MyDelivery> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              CustomFilter(
                                text: 'All',
                                isActive: true,
                                radius: 25,
                              ),
                              Gap(
                                15,
                                isHorizontal: true,
                              ),
                              CustomFilter(
                                text: 'Sold Out',
                                radius: 25,
                              ),
                              Gap(
                                15,
                                isHorizontal: true,
                              ),
                              CustomFilter(
                                text: 'Low In Stock',
                                radius: 25,
                              ),
                              Gap(
                                15,
                                isHorizontal: true,
                              ),
                              CustomFilter(
                                text: 'Low In Stock',
                                radius: 25,
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DeliveryCards(
                            id: '111234',
                            date: '2025-04-01 00:00:00',
                            name: 'Coke',
                            size: 'Small',
                            paymentStatus: 'Pending',
                            companyName: 'GIG',
                            companyNumber: '09016482578',
                            amount: 6000,
                            profileImage: ""),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
