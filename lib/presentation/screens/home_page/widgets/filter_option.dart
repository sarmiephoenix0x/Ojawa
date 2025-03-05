import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/home_page_controller.dart';

class FilterOption extends StatelessWidget {
  final String text;

  const FilterOption({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageController>(
        builder: (context, homePageController, child) {
      return ValueListenableBuilder<String?>(
        valueListenable: homePageController.selectedFilter,
        builder: (context, selectedOption, child) {
          bool isChecked = selectedOption == text;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: const Color(0xFF008000),
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  // Toggle the checkbox for the current option
                  if (value == true) {
                    // Set this option as selected, unchecking others
                    homePageController.selectedFilter.value = text;
                  } else {
                    // Deselect the option
                    homePageController.selectedFilter.value = null;
                  }
                },
              ),
              Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
