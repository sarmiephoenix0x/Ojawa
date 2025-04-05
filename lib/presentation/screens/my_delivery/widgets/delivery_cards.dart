import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_gap.dart';

class DeliveryCards extends StatelessWidget {
  final String id;
  final String date;
  final String name;
  final String size;
  final String paymentStatus;
  final String companyName;
  final String companyNumber;
  final int amount;
  final String profileImage;

  const DeliveryCards({
    super.key,
    required this.id,
    required this.date,
    required this.name,
    required this.size,
    required this.paymentStatus,
    required this.companyName,
    required this.amount,
    required this.companyNumber,
    required this.profileImage,
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
                  Expanded(
                    flex: 6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID: $id",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Row(children: [
                            IconButton(
                              icon: Icon(
                                Icons.date_range,
                                size: 30,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: null,
                            ),
                            Flexible(
                              child: Text(
                                date,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ]),
                        ]),
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 20,
              ),
            ),
            const Gap(10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Size: $size",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ]),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      size: 30,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            const Gap(30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    "Total",
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 20,
              ),
            ),
            const Gap(10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  if (profileImage == null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: Container(
                        width: (65 / MediaQuery.of(context).size.width) *
                            MediaQuery.of(context).size.width,
                        height: (65 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height,
                        color: Colors.grey,
                        child: Image.asset(
                          'images/Profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (profileImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: Container(
                        width: (55 / MediaQuery.of(context).size.width) *
                            MediaQuery.of(context).size.width,
                        height: (55 / MediaQuery.of(context).size.height) *
                            MediaQuery.of(context).size.height,
                        color: Colors.grey,
                        child: Image.network(
                          profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                            ); // Fallback if image fails
                          },
                        ),
                      ),
                    ),
                  const Gap(5, isHorizontal: true),
                  Expanded(
                    flex: 6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            companyNumber,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ]),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: null,
                  ),
                  const Gap(5, isHorizontal: true),
                  IconButton(
                    icon: Icon(
                      Icons.phone,
                      size: 30,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            const Gap(10),
            const CustomButton(
              text: 'Mark As Delivery',
              width: double.infinity,
              isPaddingActive: false,
            )
          ],
        ),
      ),
    );
  }
}
