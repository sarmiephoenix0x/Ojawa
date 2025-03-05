import 'package:flutter/material.dart';

import '../../../../../core/widgets/filter_widget.dart';
import '../../../../../core/widgets/review_widget.dart';
import '../../../home_page/widgets/bottom_sheets/sort_by_sheet.dart';
import '../../../../../core/widgets/filter_by.dart';

void showReviewsSheet(
    BuildContext context, List<Map<String, dynamic>> reviews) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Review & Rating',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(0.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      filterBy(context);
                    },
                    child: const FilterWidget(
                        img: 'images/Filter.png', text: 'Filter'),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      sortBy(context);
                    },
                    child: const FilterWidget(
                        img: 'images/sort.png', text: 'Sort By'),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ...reviews.map((review) {
              return ReviewWidget(
                starNum: review['rating'] ?? 0,
                title: review['headline'] ?? 'No headline',
                reviewText: review['body'] ?? 'No body available',
                reviewer: review['username'] ?? 'Anonymous',
                date: review['dateCreated'] ?? 'N/A',
                img: review['userProfilePicture'] ?? '',
              );
            }).toList(),
          ],
        ),
      ),
    ),
  );
}
