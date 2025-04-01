import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/add_new_product_controller.dart';

class ProductOption extends StatelessWidget {
  final String text;
  final int value;
  final int? selectedRadioValue;
  final void Function(int value) setSelectedRadioValue;

  const ProductOption(
      {super.key,
      required this.text,
      required this.value,
      required this.selectedRadioValue,
      required this.setSelectedRadioValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          print("Value before: $value");
          setSelectedRadioValue(value); // Update selected value
          print("Value after: $value");
        },
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: selectedRadioValue == value ? 3 : 0.8,
                  color: selectedRadioValue == value
                      ? const Color(0xFF1D4ED8)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
