import 'package:flutter/material.dart';

class SizeWidget extends StatelessWidget {
  final String text;
  final int value;
  final void Function(int) controllerMethod;
  final int controllerVariable;

  const SizeWidget(
      {super.key,
      required this.text,
      required this.value,
      required this.controllerMethod,
      required this.controllerVariable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {
            controllerMethod(value);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: controllerVariable == value
                  ? const Color(0xFF1D4ED8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 0.8,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
