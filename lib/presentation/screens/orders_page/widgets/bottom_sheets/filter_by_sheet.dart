import 'package:flutter/material.dart';

import '../../../../../core/widgets/filter.dart';

void filterBy(BuildContext context, void Function(int) controllerMethod,
    int controllerVariable) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Filter',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Status Type',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ),
                ListTile(
                  title: Filter(
                      text: "Upcoming",
                      value: 1,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                ListTile(
                  title: Filter(
                      text: "Cancelled",
                      value: 2,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                ListTile(
                  title: Filter(
                      text: "Delivered",
                      value: 3,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                const Divider(), // Divider between the two sections
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Filter Time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ),
                ListTile(
                  title: Filter(
                      text: "Last 30 Days",
                      value: 1,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                ListTile(
                  title: Filter(
                      text: "6 Months",
                      value: 2,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                ListTile(
                  title: Filter(
                      text: "2024",
                      value: 3,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                ListTile(
                  title: Filter(
                      text: "2023",
                      value: 1,
                      controllerMethod: controllerMethod,
                      controllerVariable: controllerVariable),
                  onTap: null,
                ),
                SizedBox(
                    height: (28 / MediaQuery.of(context).size.height) *
                        MediaQuery.of(context).size.height),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
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
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
