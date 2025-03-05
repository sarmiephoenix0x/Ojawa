import 'package:flutter/material.dart';

import '../../productDetails/productDetails.dart';

class Deal extends StatelessWidget {
  final int itemId;
  final String name;
  final List<String> img;
  final String details;
  final String amount;
  final String slashedPrice;
  final String discount;
  final String starImg;
  final String rating;
  final String rating2;
  final String text2;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const Deal({
    super.key,
    required this.itemId,
    required this.name,
    required this.img,
    required this.details,
    required this.amount,
    required this.slashedPrice,
    required this.discount,
    required this.starImg,
    required this.rating,
    required this.rating2,
    required this.text2,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Productdetails(
                  key: UniqueKey(),
                  itemId: itemId,
                  name: name,
                  details: details,
                  amount: amount,
                  slashedPrice: slashedPrice,
                  rating: rating,
                  rating2: rating2,
                  img: img,
                  discount: discount,
                  starImg: starImg,
                  onToggleDarkMode: onToggleDarkMode,
                  isDarkMode: isDarkMode),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                img[0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                  ); // Fallback if image fails
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              details,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                text2,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
