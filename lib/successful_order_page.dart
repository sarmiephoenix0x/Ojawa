import 'package:flutter/material.dart';
import 'package:ojawa/add_new_card.dart';

class SuccessfulOrderPage extends StatefulWidget {
  const SuccessfulOrderPage({super.key});

  @override
  _SuccessfulOrderPageState createState() => _SuccessfulOrderPageState();
}

class _SuccessfulOrderPageState extends State<SuccessfulOrderPage> {
  final ValueNotifier<String> selectedSizeNotifier = ValueNotifier<String>("L");
  final ValueNotifier<int> quantityNotifier = ValueNotifier<int>(1);
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
                      child: item(
                        'images/Img2.png',
                        'Calvin Clein Regular fit slim fit shirt',
                        '\$52',
                        '\$60',
                        '20% off',
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

  Widget item(String img, String details, String amount, String slashedPrice,
      String discount) {
    final ValueNotifier<String> selectedSizeNotifier =
        ValueNotifier<String>("L");
    final ValueNotifier<int> quantityNotifier = ValueNotifier<int>(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left-side Image with Remove button below
            Column(
              children: [
                // Image with dynamic height based on content
                Image.asset(
                  img,
                  width: 100,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(
                width: (16.0 / MediaQuery.of(context).size.width) *
                    MediaQuery.of(context).size.width),
            // Right-side Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details,
                    style: const TextStyle(fontSize: 16.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                      height: (10.0 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  Row(
                    children: [
                      Text(
                        amount,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(
                          width: (16.0 / MediaQuery.of(context).size.width) *
                              MediaQuery.of(context).size.width),
                      Text(
                        slashedPrice,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          decorationColor: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width: (16.0 / MediaQuery.of(context).size.width) *
                              MediaQuery.of(context).size.width),
                      Text(
                        discount,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: (10.0 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height),
                  // Size Dropdown and Quantity Selector
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     // Size Dropdown
                  //     ValueListenableBuilder<String>(
                  //       valueListenable: selectedSizeNotifier,
                  //       builder: (context, selectedSize, child) {
                  //         return Container(
                  //           padding:
                  //               const EdgeInsets.symmetric(horizontal: 8.0),
                  //           decoration: BoxDecoration(
                  //             color: const Color.fromARGB(20, 0, 0, 0),
                  //             borderRadius: BorderRadius.circular(8.0),
                  //           ),
                  //           child: Row(
                  //             children: [
                  //               DropdownButton<String>(
                  //                 value: selectedSize,
                  //                 underline:
                  //                     SizedBox(), // Remove default underline
                  //                 items: ['S', 'M', 'L', 'XL', 'XXL']
                  //                     .map((String size) {
                  //                   return DropdownMenuItem<String>(
                  //                     value: size,
                  //                     child: Text(size),
                  //                   );
                  //                 }).toList(),
                  //                 onChanged: (String? newSize) {
                  //                   if (newSize != null) {
                  //                     selectedSizeNotifier.value =
                  //                         newSize; // Update size
                  //                   }
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //     // Quantity Selector
                  //     ValueListenableBuilder<int>(
                  //       valueListenable: quantityNotifier,
                  //       builder: (context, quantity, child) {
                  //         return Container(
                  //           decoration: BoxDecoration(
                  //             color: const Color.fromARGB(20, 0, 0, 0),
                  //             borderRadius: BorderRadius.circular(8.0),
                  //           ),
                  //           padding:
                  //               const EdgeInsets.symmetric(horizontal: 8.0),
                  //           child: Row(
                  //             children: [
                  //               IconButton(
                  //                 icon: const Icon(Icons.remove),
                  //                 onPressed: () {
                  //                   if (quantity > 1) {
                  //                     quantityNotifier.value =
                  //                         quantity - 1; // Decrease quantity
                  //                   }
                  //                 },
                  //               ),
                  //               Text('$quantity',
                  //                   style: const TextStyle(fontSize: 18)),
                  //               IconButton(
                  //                 icon: const Icon(Icons.add),
                  //                 onPressed: () {
                  //                   quantityNotifier.value =
                  //                       quantity + 1; // Increase quantity
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align Remove to the right
          children: [
            const Text(
              "View Details",
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next, color: Color(0xFF1D4ED8)),
              onPressed: () {}, // Call the callback on press
            ),
          ],
        ),
      ],
    );
  }
}
