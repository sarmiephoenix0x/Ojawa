import 'package:flutter/material.dart';

void sortBy(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ListTile(
            title: Text(
          'Sort By',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        ListTile(
          title: const Text('Price - High to Low'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Price - Low to High'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Popularity'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Discount'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Customer Rating'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
