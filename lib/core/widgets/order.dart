import 'package:flutter/material.dart';

import 'custom_gap.dart';
import 'track_order_sheet.dart';

class OrderWidget extends StatelessWidget {
  final String img;
  final String type;
  final String date;
  final String prodImg;
  final String prodDetails;
  final String prodSize;
  final String prodColor;
  final Function goToOrdersPage;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const OrderWidget({
    super.key,
    required this.img,
    required this.type,
    required this.date,
    required this.prodImg,
    required this.prodDetails,
    required this.prodSize,
    required this.prodColor,
    required this.goToOrdersPage,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.2), // Softer shadow for a clean look
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2), // Position shadow for depth
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => OrderDetails(
                  //       key: UniqueKey(),
                  //       //goToOrdersPage: goToOrdersPage,
                  //       onToggleDarkMode: onToggleDarkMode,
                  //       isDarkMode: isDarkMode,
                  //     ),
                  //   ),
                  // );
                },
                child: Row(
                  children: [
                    Image.asset(
                      img,
                      height: 30,
                    ),
                    Gap(MediaQuery.of(context).size.width * 0.04,
                        isHorizontal: true, useMediaQuery: false),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OrderDetails(
                        //       key: UniqueKey(),
                        //       //goToOrdersPage: goToOrdersPage,
                        //       onToggleDarkMode: onToggleDarkMode,
                        //       isDarkMode: isDarkMode,
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Gap(MediaQuery.of(context).size.height * 0.01,
                useMediaQuery: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                ),
              ),
            ),
            Gap(MediaQuery.of(context).size.height * 0.02,
                useMediaQuery: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      prodImg,
                      width: 100,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(16.0, isHorizontal: true),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            prodDetails,
                            softWrap: true,
                            style: const TextStyle(fontSize: 16.0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Size:",
                                    style: TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Gap(6.0, isHorizontal: true),
                                  Text(
                                    prodSize,
                                    style: const TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const Gap(20.0, isHorizontal: true),
                              Row(
                                children: [
                                  const Text(
                                    "Color:",
                                    style: TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Gap(6.0, isHorizontal: true),
                                  Text(
                                    prodColor,
                                    style: const TextStyle(fontSize: 14.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(MediaQuery.of(context).size.height * 0.02,
                useMediaQuery: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  color: Colors.grey,
                  height: 20,
                ),
              ),
            ),
            Gap(MediaQuery.of(context).size.height * 0.02,
                useMediaQuery: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      height: (50 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Theme.of(context).colorScheme.onSurface;
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
                              return Theme.of(context).colorScheme.onSurface;
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      height: (50 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          trackOrder(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Theme.of(context).colorScheme.onSurface;
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
                              return Theme.of(context).colorScheme.onSurface;
                            },
                          ),
                          elevation: WidgetStateProperty.all<double>(4.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Track',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
