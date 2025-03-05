import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/new_address_controller.dart';

void submittedAddress(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/Tick.png', // Replace with the item's image asset or network path
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(
              height: (28 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height),
          const Center(
            child: Text(
              'Address Submitted Successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
              height: (28 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height),
          Container(
            width: double.infinity,
            height: (60 / MediaQuery.of(context).size.height) *
                MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white;
                    }
                    return const Color(0xFF1D4ED8);
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return const Color(0xFF1D4ED8);
                    }
                    return Colors.white;
                  },
                ),
                elevation: WidgetStateProperty.all<double>(4.0),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              child: Provider.of<NewAddressController>(context, listen: false)
                      .isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}
