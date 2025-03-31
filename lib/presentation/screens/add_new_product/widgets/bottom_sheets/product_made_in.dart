import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_gap.dart';
import '../../../../../core/widgets/custom_text_field.dart';

void productMadeIn(BuildContext context, TextEditingController controller,
    FocusNode focusNode) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
                title: Text(
              'Product Made In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )),
            CustomTextField(
              controller: controller,
              focusNode: focusNode,
              label: 'Type where the product was made',
            ),
            const Gap(10),
          ],
        ),
      ),
    ),
  );
}
