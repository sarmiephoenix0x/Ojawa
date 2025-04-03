import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/widgets/auth_button.dart';
import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/auth_password_field.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/auth_title.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllers/sign_up_controller.dart';
import 'widgets/bottom_sheets/role_sheet.dart';

class SignUpPage extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  const SignUpPage(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final signUpController = Provider.of<SignUpController>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 1.7
                    : MediaQuery.of(context).size.height * 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const AuthTitle(
                      title: 'Sign up',
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Center(
                      child: Stack(
                        children: [
                          if (signUpController.profileImage.isEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Container(
                                width:
                                    (111 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (111 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                color: Colors.grey,
                                child: Image.asset(
                                  'images/Profile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Container(
                                width:
                                    (111 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (111 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                color: Colors.grey,
                                child: Image.file(
                                  File(signUpController.profileImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                signUpController.selectImage();
                              },
                              child: Image.asset(
                                height: 35,
                                'images/profile_edit.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    const AuthLabel(title: 'Username'),
                    const Gap(5),
                    CustomTextField(
                      controller: signUpController.userNameController,
                      focusNode: signUpController.userNameFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Email'),
                    const Gap(5), const Gap(5),
                    CustomTextField(
                      label: 'example@gmail.com',
                      controller: signUpController.emailController,
                      focusNode: signUpController.emailFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Phone Number'),
                    const Gap(5),
                    Form(
                      key: signUpController.formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[900]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                    5), // Smoother corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(
                                        0, 2), // Position shadow for depth
                                  ),
                                ],
                              ),
                              child: IntlPhoneField(
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  counterText: '',
                                ),
                                initialCountryCode: 'NG',
                                // Set initial country code
                                onChanged: (phone) {
                                  setState(() {
                                    signUpController.phoneNumber =
                                        phone.completeNumber;
                                    signUpController.localPhoneNumber =
                                        phone.number;
                                  });
                                },
                                onCountryChanged: (country) {
                                  print('Country changed to: ${country.name}');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Gender'),
                    const Gap(5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[900] : Colors.white,
                          borderRadius:
                              BorderRadius.circular(5), // Smoother corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(
                                  0, 2), // Position shadow for depth
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: signUpController.selectedGender,
                          onChanged: (String? newValue) {
                            setState(() {
                              signUpController.selectedGender = newValue!;
                            });
                          },
                          items: <String>['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'State'),
                    const Gap(5),
                    CustomTextField(
                      controller: signUpController.stateController,
                      focusNode: signUpController.stateFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'New Password'),
                    const Gap(5),
                    AuthPasswordField(
                      controller: signUpController.passwordController,
                      focusNode: signUpController.passwordFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Retype Password'),
                    const Gap(5),
                    AuthPasswordField(
                      controller: signUpController.password2Controller,
                      focusNode: signUpController.password2FocusNode,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: AuthLabel(title: 'Role'),
                    ),
                    const Gap(5),
                    CustomTextField(
                      controller: signUpController.roleController,
                      focusNode: signUpController.roleFocusNode,
                      label: 'Select Role',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          showRoleSelection(
                              context, signUpController.setSelectedRole);
                        },
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    AuthButton(
                      onPressed: () {
                        if (signUpController.isLoading == false) {
                          signUpController.registerUser(context,
                              widget.onToggleDarkMode, widget.isDarkMode);
                        }
                      },
                      isLoading: signUpController.isLoading,
                      label: 'Next',
                    ),

                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    // const Center(
                    //   child: Text(
                    //     '- Or -',
                    //     style: TextStyle(
                    //       fontFamily: 'Poppins',
                    //       fontSize: 13.0,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Image.asset(
                    //         'images/flat-color-icons_google.png',
                    //       ),
                    //       SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.05),
                    //       Image.asset(
                    //         'images/logos_facebook.png',
                    //       ),
                    //       SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.05),
                    //       Image.asset(
                    //         'images/bi_apple.png',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
