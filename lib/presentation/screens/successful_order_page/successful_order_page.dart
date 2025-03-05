import 'package:flutter/material.dart';

import 'widgets/item.dart';

class SuccessfulOrderPage extends StatefulWidget {
  const SuccessfulOrderPage({super.key});

  @override
  _SuccessfulOrderPageState createState() => _SuccessfulOrderPageState();
}

class _SuccessfulOrderPageState extends State<SuccessfulOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height: (28 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    Image.asset(
                      'images/Tick.png', // Replace with the item's image asset or network path
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                        height: (28 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    const Center(
                      child: Text(
                        'Thank you!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: (22 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    const Text(
                      "Your order has been successfully placed",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: (38 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    SizedBox(
                      height: (200 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      child: const Item(
                        img: 'images/Img2.png',
                        details: 'Calvin Clein Regular fit slim fit shirt',
                        amount: '\$52',
                        slashedPrice: '\$60',
                        discount: '20% off',
                      ),
                    ),
                    SizedBox(
                        height: (38 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Delivery to",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: (10 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "[Address Of The Receiver]",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: (10 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Image.asset(
                            'images/Delivery-truck.png',
                            height: 25,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          const Text(
                            "Get it by Web, Feb 02",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: (10 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Image.asset(
                            'images/Exchange.png',
                            height: 25,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          const Text(
                            "30 days Exchange/Return Available",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: (38 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5, // Adjust flex for title width distribution
                          child: Text(
                            "Total Payable Amount",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 4, // Adjust flex for name width distribution
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "\$87",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: (68 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    Container(
                      width: double.infinity,
                      height: (55 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.white;
                              }
                              return const Color(0xFF1D4ED8);
                            },
                          ),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color(0xFF1D4ED8);
                              }
                              return Colors.white;
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 3, color: Color(0xFF1D4ED8)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Track Order',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: (20 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height),
                    Container(
                      width: double.infinity,
                      height: (55 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return const Color(0xFF1D4ED8);
                              }
                              return Colors.white;
                            },
                          ),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.white;
                              }
                              return const Color(0xFF1D4ED8);
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 3, color: Color(0xFF1D4ED8)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Continue shopping',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
