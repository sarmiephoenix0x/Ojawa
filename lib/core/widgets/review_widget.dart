import 'package:flutter/material.dart';

import 'custom_gap.dart';
import 'image_list.dart';

class ReviewWidget extends StatelessWidget {
  final int starNum;
  final String title;
  final String reviewText;
  final String reviewer;
  final String date;
  final String img;

  const ReviewWidget({
    super.key,
    required this.starNum,
    required this.title,
    required this.reviewText,
    required this.reviewer,
    required this.date,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: [
                ...List.generate(
                  5 - starNum,
                  (index) =>
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
                // ...List.generate(
                //   5 - starNum,
                //   (index) => const Icon(Icons.star_border,
                //       color: Colors.grey, size: 20),
                // ),
              ],
            ),
          ),
          Gap(MediaQuery.of(context).size.height * 0.02, useMediaQuery: false),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              reviewText,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
          ),
          if (img.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ImageList(img: img),
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              '$reviewer, $date',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
