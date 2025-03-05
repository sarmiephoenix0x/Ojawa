import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../core/widgets/auth_button.dart';
import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/auth_password_field.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/auth_title.dart';
import '../../controllers/sign_up_controller.dart';

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
    final signUpController = Provider.of<SignUpController>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height * 1.4
                    : MediaQuery.of(context).size.height * 2.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const AuthTitle(
                      title: 'Sign up',
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    const AuthLabel(title: 'Username'),

                    AuthTextField(
                      controller: signUpController.userNameController,
                      focusNode: signUpController.userNameFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Email'),

                    AuthTextField(
                      label: 'example@gmail.com',
                      controller: signUpController.emailController,
                      focusNode: signUpController.emailFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Phone Number'),

                    Form(
                      key: signUpController.formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Gender'),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'State'),
                    AuthTextField(
                      controller: signUpController.stateController,
                      focusNode: signUpController.stateFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'New Password'),

                    AuthPasswordField(
                      controller: signUpController.passwordController,
                      focusNode: signUpController.passwordFocusNode,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const AuthLabel(title: 'Retype Password'),

                    AuthPasswordField(
                      controller: signUpController.password2Controller,
                      focusNode: signUpController.password2FocusNode,
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
