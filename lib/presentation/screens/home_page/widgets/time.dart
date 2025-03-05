import 'package:flutter/material.dart';

class Time extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;

  const Time({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          hours.toString().padLeft(2, '0'), // Format to 2 digits
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        const Text(
          'HRS',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        Text(
          minutes.toString().padLeft(2, '0'), // Format to 2 digits
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        const Text(
          'MIN',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        Text(
          seconds.toString().padLeft(2, '0'), // Format to 2 digits
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        const Text(
          'SEC',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
