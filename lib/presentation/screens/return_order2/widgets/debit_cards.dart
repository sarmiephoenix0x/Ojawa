import 'package:flutter/material.dart';

class DebitCards extends StatelessWidget {
  final String text;
  final int value;
  final void Function(int) controllerMethod;
  final int controllerVariable;

  const DebitCards(
      {super.key,
      required this.text,
      required this.value,
      required this.controllerMethod,
      required this.controllerVariable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          controllerMethod(value); // Update selected value
        },
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.credit_card,
                color: Theme.of(context).colorScheme.onSurface,
                size: 30,
              ),
              onPressed: () {},
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: controllerVariable == value ? 3 : 0.8,
                  color: controllerVariable == value
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
