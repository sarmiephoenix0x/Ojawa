import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/write_review_controller.dart';

class StarRating extends StatelessWidget {
  final int starCount;

  const StarRating({
    super.key,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            Provider.of<WriteReviewController>(context, listen: false)
                .setStarCount(index + 1);
          },
          child: Icon(
            index < starCount ? Icons.star : Icons.star_border,
            color: index < starCount ? Colors.yellow : Colors.grey,
            size: 28.0,
          ),
        );
      }),
    );
  }
}
