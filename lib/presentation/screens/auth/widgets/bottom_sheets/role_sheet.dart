import 'package:flutter/material.dart';

void showRoleSelection(
    BuildContext context, void Function(String) setSelectedRole) {
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
            'Select Your Role',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Customer'),
            onTap: () {
              setSelectedRole("Customer");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Vendor'),
            onTap: () {
              setSelectedRole("Vendor");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text('Logistics'),
            onTap: () {
              setSelectedRole("Logistics");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
