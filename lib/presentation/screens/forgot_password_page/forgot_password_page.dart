import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/auth_password_field.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../controllers/forgot_password_page_controller.dart';

class ForgotPassword extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  const ForgotPassword(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // final forgotPasswordPageController =
    //     Provider.of<ForgotPasswordPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordPageController(vsync: this),
      child: Consumer<ForgotPasswordPageController>(
          builder: (context, forgotPasswordPageController, child) {
        return Scaffold(
          body: // Reset Password Tab
              SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'images/tabler_arrow-back.png',
                          height: 50,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 10,
                        child: Text(
                          'Forgot Password',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const AuthLabel(title: 'Email'),
                AuthTextField(
                  label: 'example@gmail.com',
                  controller: forgotPasswordPageController.emailController,
                  focusNode: forgotPasswordPageController.emailFocusNode,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const AuthLabel(title: 'Token'),
                AuthTextField(
                  controller: forgotPasswordPageController.tokenController,
                  focusNode: forgotPasswordPageController.tokenFocusNode,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  height: (60 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: forgotPasswordPageController.isLoading
                        ? null
                        : forgotPasswordPageController.resetPasswordRequest,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white;
                          }
                          return Colors.black;
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.black;
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
                    child: forgotPasswordPageController.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Request Token'),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const AuthLabel(title: 'New Password'),
                AuthPasswordField(
                  controller: forgotPasswordPageController.passwordController,
                  focusNode: forgotPasswordPageController.passwordFocusNode,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const AuthLabel(title: 'Retype Password'),
                AuthPasswordField(
                  controller: forgotPasswordPageController.password2Controller,
                  focusNode: forgotPasswordPageController.password2FocusNode,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  width: double.infinity,
                  height: (60 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: forgotPasswordPageController.isLoading2
                        ? null
                        : () => forgotPasswordPageController.resetPassword(
                            context,
                            widget.onToggleDarkMode,
                            widget.isDarkMode),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white;
                          }
                          return Colors.black;
                        },
                      ),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.black;
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
                    child: forgotPasswordPageController.isLoading2
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Reset Password'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
