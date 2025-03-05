import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/filter.dart';
import '../../controllers/profile_page_controller.dart';
import '../edit_profile/edit_profile.dart';
import '../../../main.dart';

class ProfilePage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfilePage({
    super.key,
    required this.goToProfilePage,
    required this.goToCategoriesPage,
    required this.goToOrdersPage,
    // required this.scaffoldKey
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profilePageController = Provider.of<ProfilePageController>(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
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
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        const Text('My Profile',
                            style: TextStyle(fontSize: 20)),
                        const Spacer(),
                        Container(
                          height: (40 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const Color(0xFF1D4ED8);
                                  }
                                  return Colors.white;
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.white;
                                  }
                                  return const Color(0xFF1D4ED8);
                                },
                              ),
                              elevation: WidgetStateProperty.all<double>(4.0),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2, color: Color(0xFF1D4ED8)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            if (profilePageController.profileImage == null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Container(
                                  width:
                                      (85 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (85 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  color: Colors.grey,
                                  child: Image.asset(
                                    'images/Profile.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else if (profilePageController.profileImage != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Container(
                                  width:
                                      (85 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (85 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  color: Colors.grey,
                                  child: Image.network(
                                    profilePageController.profileImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                      ); // Fallback if image fails
                                    },
                                  ),
                                ),
                              ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => EditProfile(
                            //             key: UniqueKey(),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     child: Image.asset(
                            //       height: 30,
                            //       'images/profile_edit.png',
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: AuthTextField(
                            label: 'Name',
                            controller: profilePageController.nameController,
                            focusNode: profilePageController.nameFocusNode,
                            labelFontSize: 16.0,
                            isPaddingActive: false,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: AuthTextField(
                            label: 'Email',
                            controller: profilePageController.emailController,
                            focusNode: profilePageController.emailFocusNode,
                            labelFontSize: 16.0,
                            isPaddingActive: false,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: AuthTextField(
                            label: 'Phone Number',
                            controller:
                                profilePageController.phoneNumberController,
                            focusNode:
                                profilePageController.phoneNumberFocusNode,
                            labelFontSize: 16.0,
                            isPaddingActive: false,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: AuthTextField(
                            label: 'Location',
                            controller:
                                profilePageController.locationController,
                            focusNode: profilePageController.locationFocusNode,
                            labelFontSize: 16.0,
                            isPaddingActive: false,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AbsorbPointer(
                          child: Row(
                            children: [
                              Filter(
                                  text: 'Male',
                                  value: 1,
                                  controllerMethod: profilePageController
                                      .setSelectedRadioValue,
                                  controllerVariable: profilePageController
                                      .selectedRadioValue!),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              Filter(
                                  text: 'Female',
                                  value: 2,
                                  controllerMethod: profilePageController
                                      .setSelectedRadioValue,
                                  controllerVariable: profilePageController
                                      .selectedRadioValue!),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              Filter(
                                  text: 'Other',
                                  value: 3,
                                  controllerMethod: profilePageController
                                      .setSelectedRadioValue,
                                  controllerVariable:
                                      profilePageController.selectedRadioValue!)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
