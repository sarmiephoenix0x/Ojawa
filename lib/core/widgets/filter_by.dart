import 'package:flutter/material.dart';

void filterBy(BuildContext context) {
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
            'Filter By',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
          ListTile(
            title: const Text('All Star'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('5 Star'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('4 Star'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('3 Star'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('2 Star'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('1 Star'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
