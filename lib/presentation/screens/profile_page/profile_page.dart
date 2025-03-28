import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/logout_dialog.dart';
import '../../controllers/profile_page_controller.dart';
import '../edit_profile/edit_profile.dart';
import 'widgets/profile_options.dart';
import 'widgets/profile_options_bg.dart';

class ProfilePage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfilePage({
    super.key,
    required this.goToProfilePage,
    required this.goToCategoriesPage,
    required this.goToOrdersPage,
    required this.onToggleDarkMode,
    required this.isDarkMode,
    // required this.scaffoldKey
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (context) => ProfilePageController(
          onToggleDarkMode: widget.onToggleDarkMode,
          isDarkMode: widget.isDarkMode),
      child: Consumer<ProfilePageController>(
          builder: (context, profilePageController, child) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        profilePageController.refreshData(context);
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        if (profilePageController
                                                .profileImage ==
                                            null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            child: Container(
                                              width: (65 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              height: (65 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              color: Colors.grey,
                                              child: Image.asset(
                                                'images/Profile.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        else if (profilePageController
                                                .profileImage !=
                                            null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            child: Container(
                                              width: (55 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              height: (55 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              color: Colors.grey,
                                              child: Image.network(
                                                profilePageController
                                                    .profileImage!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                  ); // Fallback if image fails
                                                },
                                              ),
                                            ),
                                          ),
                                        const Gap(5, isHorizontal: true),
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                profilePageController
                                                        .userName ??
                                                    'User',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                              const Gap(2),
                                              Text(
                                                profilePageController.email ??
                                                    'Loading...',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 6,
                                                right: 6,
                                                top: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: isDarkMode
                                                  ? Colors.grey[900]
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // Smoother corners
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(
                                                      0.2), // Softer shadow for a clean look
                                                  spreadRadius: 2,
                                                  blurRadius: 8,
                                                  offset: const Offset(0,
                                                      2), // Position shadow for depth
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'images/Wallet2.png',
                                                    height: 20),
                                                const Gap(
                                                  10,
                                                  isHorizontal: true,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    'N 6,000,000',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
                            ProfileOptionsBG(
                              children: [
                                ProfileOptions(
                                  title: 'Edit Profile',
                                  img: 'images/Edit Profile.png',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const ProfileOptions(
                                  title: 'Orders',
                                  img: 'images/Orders2.png',
                                ),
                                const ProfileOptions(
                                  title: 'Chat',
                                  img: 'images/Chat.png',
                                ),
                              ],
                            ),
                            const ProfileOptionsBG(
                              children: [
                                ProfileOptions(
                                  title: 'Wallet History',
                                  img: 'images/Wallet History.png',
                                ),
                                ProfileOptions(
                                  title: 'Products',
                                  img: 'images/Products2.png',
                                ),
                                ProfileOptions(
                                  title: 'Add New Products',
                                  img: 'images/Add New Products.png',
                                ),
                                ProfileOptions(
                                  title: 'Manage PickUp Location',
                                  img: 'images/Manage PickUp Location.png',
                                ),
                                ProfileOptions(
                                  title: 'Stock Management',
                                  img: 'images/Stock Management.png',
                                ),
                              ],
                            ),
                            const ProfileOptionsBG(
                              children: [
                                ProfileOptions(
                                  title: 'Change Language',
                                  img: 'images/Change Language.png',
                                ),
                                ProfileOptions(
                                  title: 'Terms and Conditions',
                                  img: 'images/Terms and Conditions.png',
                                ),
                                ProfileOptions(
                                  title: 'Privacy Policy',
                                  img: 'images/Privacy Policy.png',
                                ),
                              ],
                            ),
                            const ProfileOptionsBG(
                              children: [
                                ProfileOptions(
                                  title: 'Contact Us',
                                  img: 'images/Contact Us.png',
                                ),
                                ProfileOptions(
                                  title: 'Return Policy',
                                  img: 'images/Return Policy.png',
                                ),
                                ProfileOptions(
                                  title: 'Shipping Policy',
                                  img: 'images/Shipping Policy.png',
                                ),
                              ],
                            ),
                            ProfileOptionsBG(
                              children: [
                                const ProfileOptions(
                                  title: 'Delete Account',
                                  img: 'images/Delete Account.png',
                                ),
                                ProfileOptions(
                                  title: 'Logout',
                                  img: 'images/Logout2.png',
                                  onTap: () {
                                    showLogoutDialog(
                                        context, profilePageController.logout);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
