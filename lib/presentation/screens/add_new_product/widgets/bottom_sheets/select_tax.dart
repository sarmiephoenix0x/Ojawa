import 'package:flutter/material.dart';

void selectTax(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
              title: Text(
            'Select Tax',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
          ListTile(
            title: const Text('NIL'),
            trailing: const Text('0%'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('GSTs'),
            trailing: const Text('18%'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('GST'),
            trailing: const Text('5%'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
