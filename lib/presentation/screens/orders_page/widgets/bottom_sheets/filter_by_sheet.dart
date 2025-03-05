import 'package:flutter/material.dart';

import '../../../../../core/widgets/filter_modal.dart';

void filterBy(
    BuildContext context,
    void Function(int) controllerMethod,
    void Function(int) controllerMethod2,
    int controllerVariable,
    int controllerVariable2) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FilterModal(
            initialSelectedValue: controllerVariable, // Pass the initial value
            initialSelectedTimeValue: controllerVariable2,
            controllerMethod: controllerMethod,
          );
        },
      );
    },
  );
}
