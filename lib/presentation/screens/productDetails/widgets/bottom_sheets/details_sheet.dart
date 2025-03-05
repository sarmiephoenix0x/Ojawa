import 'package:flutter/material.dart';

import '../../../../../core/widgets/specs.dart';

void showDetailsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
                height: (28 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
                height: (18 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Text(
              'Short-sleeved shirt in a patterned viscose weave with a resort collar, French front and yoke at the back. '
              'Open chest pocket and slits in the sides of the hem. Relaxed Fit—a straight fit with good room for movement, '
              'creating a comfortable relaxed silhouette.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
                height: (30 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Text(
              'Specification',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
                height: (18 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Specs(title: 'Fabric', name: 'Cotton'),
            const Specs(title: 'Length', name: 'Regular'),
            const Specs(title: 'Neck', name: 'Round Neck'),
            const Specs(title: 'Pattern', name: 'Graphic Print'),
          ],
        ),
      ),
    ),
  );
}
