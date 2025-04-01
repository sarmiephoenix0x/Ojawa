import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_gap.dart';
import 'products_button.dart';

class ProductsPageProducts extends StatelessWidget {
  final String name;
  final String img;
  final String price;
  final String buttonType;

  const ProductsPageProducts({
    super.key,
    required this.name,
    required this.img,
    required this.price,
    this.buttonType = "Normal",
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12), // Smoother corners
          boxShadow: [
            BoxShadow(
              color: Colors.black
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(
                  5,
                  isHorizontal: true,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Gap(30),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Price:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const Gap(
                            5,
                            isHorizontal: true,
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'images/Naira.png',
                                  height: 15,
                                ),
                                const Gap(2, isHorizontal: true),
                                Flexible(
                                  child: Text(
                                    '6,000.00',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: null,
                ),
              ],
            ),
            const Gap(20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                      text: 'Product FAQ',
                      fgColor: Colors.black,
                      bgColor: Colors.white,
                      borderColor: Colors.white,
                      isPaddingActive: false),
                ),
                Gap(4, isHorizontal: true),
                Expanded(
                  child: CustomButton(
                      text: 'Review',
                      fgColor: Colors.black,
                      bgColor: Colors.white,
                      borderColor: Colors.white,
                      isPaddingActive: false),
                ),
                Gap(4, isHorizontal: true),
                Expanded(
                  child: CustomButton(
                      text: 'Enable',
                      bgColor: Colors.green,
                      borderColor: Colors.green,
                      isPaddingActive: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
