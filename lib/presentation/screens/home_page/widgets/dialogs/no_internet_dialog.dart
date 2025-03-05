import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/home_page_controller.dart';

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text(
          'It looks like you are not connected to the internet. Please check your connection and try again.',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Retry', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<HomePageController>(context, listen: false)
                  .refreshData(context);
            },
          ),
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
