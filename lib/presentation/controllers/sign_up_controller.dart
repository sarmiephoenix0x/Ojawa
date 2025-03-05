import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'dart:async';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/main_app/main_app.dart';

class SignUpController extends ChangeNotifier {
  final FocusNode _displayNameFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _password2FocusNode = FocusNode();

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  bool dropDownTapped = false;

  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool isLoading = false;
  String phoneNumber = '';
  String localPhoneNumber = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedGender = 'Male';
  String _profileImage = '';
  final double maxWidth = 360;
  final double maxHeight = 360;
  final ImagePicker _picker = ImagePicker();

  SignUpController() {
    initializePrefs();
  }

  //public getters
  FocusNode get userNameFocusNode => _userNameFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get stateFocusNode => _stateFocusNode;
  FocusNode get password2FocusNode => _password2FocusNode;
  TextEditingController get userNameController => _userNameController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get emailController => _emailController;
  TextEditingController get stateController => _stateController;
  TextEditingController get password2Controller => _password2Controller;
  GlobalKey<FormState> get formKey => _formKey;

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final decodedImage =
          await decodeImageFromList(imageFile.readAsBytesSync());

      if (decodedImage.width > maxWidth || decodedImage.height > maxHeight) {
        var cropper = ImageCropper();
        CroppedFile? croppedImage = await cropper.cropImage(
            sourcePath: imageFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                lockAspectRatio: false,
              ),
              IOSUiSettings(
                minimumAspectRatio: 1.0,
              ),
            ]);

        if (croppedImage != null) {
          _profileImage = croppedImage.path;
          notifyListeners();
        }
      } else {
        _profileImage = pickedFile!.path;
        notifyListeners();
      }
    }
  }

  Future<void> registerUser(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    if (prefs == null) {
      await initializePrefs();
    }
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String passwordConfirmation = password2Controller.text.trim();
    final String state = stateController.text.trim();
    final String username = userNameController.text.trim();

    if (state.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty) {
      CustomSnackbar.show(
        'All fields are required.',
        isError: true,
      );

      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      CustomSnackbar.show(
        'Please enter a valid email address.',
        isError: true,
      );

      return;
    }

    if (password.length < 6) {
      CustomSnackbar.show(
        'Password must be at least 6 characters.',
        isError: true,
      );

      return;
    }

    if (password != passwordConfirmation) {
      CustomSnackbar.show(
        'Passwords do not match.',
        isError: true,
      );

      return;
    }

    if (!_formKey.currentState!.validate()) {
      // Show a message if validation fails
      CustomSnackbar.show(
        'Please provide a valid phone number.',
        isError: true,
      );
      return;
    }
    // if (phoneNumber.length < 11) {
    //   _showCustomSnackBar(
    //     context,
    //     'Phone number must be at least 11 characters.',
    //     isError: true,
    //   );
    //
    //   return;
    // }

    isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://ojawa-api.onrender.com/api/Auth/sign-up/buyer');
    final request = http.MultipartRequest('POST', url)
      ..fields['username'] = username
      ..fields['email'] = email
      ..fields['phone'] = localPhoneNumber
      ..fields['gender'] = selectedGender
      ..fields['state'] = state
      ..fields['password'] = password
      ..fields['confirmPassword'] = passwordConfirmation;

    // Handling profile picture upload if it's a local file
    if (_profileImage != null && !_profileImage.startsWith('http')) {
      File imageFile = File(_profileImage);
      if (await imageFile.exists()) {
        var stream =
            http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        request.files.add(http.MultipartFile(
          'profilePicture',
          stream,
          length,
          filename: path.basename(imageFile.path),
        ));
      } else {
        print('Image file not found. Skipping image upload.');
      }
    } else {
      print(
          'Skipping image upload as the profile image is from an HTTP source.');
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseData = json.decode(response.body);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final String accessToken = responseData['token'];
      final int userId = responseData['value']; // Extract userId from response

      // Store the access token and user ID
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(
          key: 'userId', value: userId.toString()); // Store userId as a string

      // Handle successful response
      CustomSnackbar.show(
        'Sign up successful!',
        isError: false,
      );

      // Navigate to the main app or another page
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
      isLoading = false;
      notifyListeners();
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String error = responseData['message'];

      // Handle validation error
      CustomSnackbar.show(
        'Error: $error',
        isError: true,
      );
    } else {
      isLoading = false;
      notifyListeners();
      // Handle other unexpected responses
      CustomSnackbar.show(
        'An unexpected error occurred.',
        isError: true,
      );
    }
  }
}
