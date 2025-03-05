import 'dart:convert';

import 'package:flutter/material.dart';

void showResponseDialog(BuildContext context, dynamic responseData) {
  // Convert the response data to a JSON string with indentation
  final String prettyJson =
      const JsonEncoder.withIndent('  ').convert(responseData);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Response Data'),
        content: Container(
          width: double.maxFinite, // Ensure the dialog takes up available space
          child: SingleChildScrollView(
            child: Text(prettyJson),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
