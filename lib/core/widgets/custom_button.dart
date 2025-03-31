import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final Color bgColor;
  final Color fgColor;
  final Color borderColor;
  final String text;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.isLoading,
    required this.text,
    this.bgColor = const Color(0xFF1D4ED8),
    this.fgColor = Colors.white,
    this.borderColor = const Color(0xFF1D4ED8),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: (60 / MediaQuery.of(context).size.height) *
            MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return fgColor;
                }
                return bgColor;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return bgColor;
                }
                return fgColor;
              },
            ),
            elevation: WidgetStateProperty.all<double>(4.0),
            shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<WidgetState> states) {
                return RoundedRectangleBorder(
                  side: BorderSide(
                    width: 3,
                    color: borderColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                );
              },
            ),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
