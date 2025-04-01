import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_attribute.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../controllers/manage_pickup_location_controllers.dart';
import '../../../core/widgets/custom_bg.dart';
import '../add_pickup_location/add_pickup_location.dart';

class ManagePickupLocation extends StatefulWidget {
  const ManagePickupLocation({super.key});

  @override
  _ManagePickupLocationState createState() => _ManagePickupLocationState();
}

class _ManagePickupLocationState extends State<ManagePickupLocation> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final managePickupLocationController =
        Provider.of<ManagePickupLocationControllers>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('Manage Pick-Up Location',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomBg(children: [
                          CustomAttribute(
                            text: 'Pick-Up Location',
                            text2: 'Test Location',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Name',
                            text2: 'Test',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Email',
                            text2: 'Test Mail',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'City',
                            text2: 'Test City',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Address',
                            text2: 'Test Address',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Additional Address',
                            text2: 'Test Address',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                              text: 'Mobile Number',
                              text2: '090939343939',
                              fontWeightTxt: FontWeight.bold,
                              isPaddingActive: false),
                        ]),
                        CustomBg(children: [
                          CustomAttribute(
                            text: 'Pick-Up Location',
                            text2: 'Test Location',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Name',
                            text2: 'Test',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Email',
                            text2: 'Test Mail',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'City',
                            text2: 'Test City',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Address',
                            text2: 'Test Address',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                            text: 'Additional Address',
                            text2: 'Test Address',
                            fontWeightTxt: FontWeight.bold,
                          ),
                          CustomAttribute(
                              text: 'Mobile Number',
                              text2: '090939343939',
                              fontWeightTxt: FontWeight.bold,
                              isPaddingActive: false),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'pickup_location_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPickupLocation(
                key: UniqueKey(),
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
