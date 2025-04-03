import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/auth/sign_up_page.dart';
import '../screens/verify_otp/verify_otp.dart';

class VerifyEmailController extends ChangeNotifier {
  bool _isLoading = false;
  bool isLoading2 = false;
  int? _selectedRadioValue = 0;
  bool _showInitialContent = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String phoneNumber = '';

  //public getters
  bool get isLoading => _isLoading;
  int? get selectedRadioValue => _selectedRadioValue;

  TextEditingController get emailController => _emailController;

  FocusNode get emailFocusNode => _emailFocusNode;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  Future<void> verifyEmail(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse('https://ojawa-api.onrender.com/api/Auth/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text.trim()}),
      );
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        final responseData = json.decode(response.body);

        // Extract the token from the response
        final String token = responseData['token'];

        // Navigate to the VerifyOtp page and pass the token

        _isLoading = false;
        notifyListeners();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtp(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode,
              email: emailController.text.trim(),
              token: token, // Pass the token here
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        // Handle validation error
        final responseData = json.decode(response.body);
        final String message = responseData['message'];
        final String status = responseData['status'];

        _isLoading = false;
        notifyListeners();
        if (status == "Partial_Success" &&
            message == "Email is already verified") {
          CustomSnackbar.show(
            '$message',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(
                  key: UniqueKey(),
                  onToggleDarkMode: onToggleDarkMode,
                  isDarkMode: isDarkMode),
            ),
          );
        } else {
          CustomSnackbar.show(
            message,
            isError: true,
          );
        }
      } else {
        // Handle other unexpected responses

        _isLoading = false;
        notifyListeners();

        CustomSnackbar.show(
          'An unexpected error occurred.',
          isError: true,
        );
      }
    } catch (error) {
      // Handle network or other errors

      _isLoading = false;
      notifyListeners();

      CustomSnackbar.show(
        'An error occurred: $error',
        isError: true,
      );
    }
  }
}
