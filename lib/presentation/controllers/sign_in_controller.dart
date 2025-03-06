import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/route/app_routes.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../data/model/app_args.dart';
import '../screens/main_app/main_app.dart';

class SignInController extends ChangeNotifier {
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  SignInController() {
    initializePrefs();
  }

  //public getters
  FocusNode get userNameFocusNode => _userNameFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  TextEditingController get userNameController => _userNameController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;

  void setRemberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> submitForm(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    if (prefs == null) {
      await initializePrefs();
    }
    final String userName = userNameController.text.trim();
    final String password = passwordController.text.trim();

    if (userName.isEmpty || password.isEmpty) {
      // Show an error message if any field is empty
      CustomSnackbar.show(
        'All fields are required.',
        isError: true,
      );

      return;
    }

    // Validate password length
    if (password.length < 6) {
      // Show an error message if password is too short
      CustomSnackbar.show(
        'Password must be at least 6 characters.',
        isError: true,
      );

      return;
    }

    _isLoading = true;
    notifyListeners();

    // Send the POST request
    final response = await http.post(
      Uri.parse('https://ojawa-api.onrender.com/api/Auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': userName,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    print('Response Data: $responseData');

    if (response.statusCode == 200) {
      _isLoading = true;
      notifyListeners();
      final Map<String, dynamic> responseData =
          json.decode(response.body); // Decode the response body
      final String accessToken = responseData['token'];
      final int userId = responseData['userId']; // Extract userId from response

      // Store the access token and user ID
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(
          key: 'userId', value: userId.toString()); // Store userId as a string

      // Handle the successful response here
      CustomSnackbar.show(
        'Sign in successful!',
        isError: false,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainApp(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode),
        ),
      );
    } else if (response.statusCode == 400) {
      _isLoading = false;
      notifyListeners();
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String error = responseData['message'];

      CustomSnackbar.show(
        'Error: $error',
        isError: true,
      );
    } else {
      _isLoading = false;
      notifyListeners();

      CustomSnackbar.show(
        'An unexpected error occurred.',
        isError: true,
      );
    }
  }
}
