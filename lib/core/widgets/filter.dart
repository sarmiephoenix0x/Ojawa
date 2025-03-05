import 'package:flutter/material.dart';

import 'custom_gap.dart';

class Filter extends StatelessWidget {
  final String text;
  final int value;
  final void Function(int) controllerMethod;
  final void Function(int)? controllerMethod2;
  final int controllerVariable;
  final int? controllerVariable2;
  final bool filterByTime;

  const Filter(
      {super.key,
      required this.text,
      required this.value,
      required this.controllerMethod,
      this.controllerMethod2,
      required this.controllerVariable,
      this.controllerVariable2,
      this.filterByTime = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: InkWell(
        onTap: () {
          if (filterByTime == false) {
            controllerMethod(value); // Update selected value
          } else {
            controllerMethod2!(value);
          }
        },
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: filterByTime == false
                      ? controllerVariable == value
                          ? 3
                          : 0.8
                      : controllerVariable2 == value
                          ? 3
                          : 0.8,
                  color: filterByTime == false
                      ? controllerVariable == value
                          ? const Color(0xFF1D4ED8)
                          : Theme.of(context).colorScheme.onSurface
                      : controllerVariable2 == value
                          ? const Color(0xFF1D4ED8)
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Gap(MediaQuery.of(context).size.width * 0.02,
                isHorizontal: true, useMediaQuery: false),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
