import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileControllers extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  int? _selectedRadioValue = 1;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _taxNameController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _storeNameFocusNode = FocusNode();
  final FocusNode _storeUrlFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _latitudeFocusNode = FocusNode();
  final FocusNode _longitudeFocusNode = FocusNode();
  final FocusNode _taxNameFocusNode = FocusNode();
  final FocusNode _taxNumberFocusNode = FocusNode();
  String _phoneNumber = '';
  int? userId;
  String? _profileImage;
  String? userName;
  String? email;
  String? state;
  String? phone;
  String? gender;
  String? role;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final double maxWidth = 360;
  final double maxHeight = 360;

  EditProfileControllers() {
    initialize();
  }

  //public getters
  String? get profileImage => _profileImage;
  bool get isLoading => _isLoading;
  int? get selectedRadioValue => _selectedRadioValue;
  String? get phoneNumber => _phoneNumber;

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get locationController => _locationController;
  TextEditingController get addressController => _addressController;
  TextEditingController get storeNameController => _storeNameController;
  TextEditingController get storeUrlController => _storeUrlController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get latitudeController => _latitudeController;
  TextEditingController get longitudeController => _longitudeController;
  TextEditingController get taxNameController => _taxNameController;
  TextEditingController get taxNumberController => _taxNumberController;

  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get locationFocusNode => _locationFocusNode;
  FocusNode get addressFocusNode => _addressFocusNode;
  FocusNode get storeNameFocusNode => _storeNameFocusNode;
  FocusNode get storeUrlFocusNode => _storeUrlFocusNode;
  FocusNode get descriptionFocusNode => _descriptionFocusNode;
  FocusNode get latitudeFocusNode => _latitudeFocusNode;
  FocusNode get longitudeFocusNode => _longitudeFocusNode;
  FocusNode get taxNameFocusNode => _taxNameFocusNode;
  FocusNode get taxNumberFocusNode => _taxNumberFocusNode;

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void initialize() {
    fetchUserProfile();
  }

  Future<int?> getUserId() async {
    try {
      // Retrieve the userId from storage
      String? userIdString =
          await storage.read(key: 'userId'); // Use the correct key for userId
      if (userIdString != null) {
        return int.tryParse(userIdString); // Convert the string to an integer
      }
    } catch (error) {
      print('Error retrieving userId: $error');
    }
    return null; // Return null if userId is not found or an error occurs
  }

  Future<void> fetchUserProfile() async {
    // Retrieve the userId from storage
    userId =
        await getUserId(); // Assuming this retrieves the userId from Flutter Secure Storage
    final String? accessToken = await storage.read(
        key: 'accessToken'); // Use the correct key for access token
    final url =
        'https://ojawa-api.onrender.com/api/Users/$userId'; // Update the URL to the correct endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Access the user data from the nested "data" key
        final userData = responseData['data'];
        userName = userData['username'];
        email = userData['email'];
        state = userData['state'];
        phone = userData['phone'];
        gender = userData['gender'];
        role = userData['role'];
        final profilePictureUrl =
            userData['profilePictureUrl']?.toString().trim();

        _profileImage =
            (profilePictureUrl != null && profilePictureUrl.isNotEmpty)
                ? '$profilePictureUrl/download?project=66e4476900275deffed4'
                : '';

        // Set the values of the TextEditingControllers
        _nameController.text = userName ?? '';
        _emailController.text = email ?? '';
        _phoneController.text = phone ?? '';
        _locationController.text =
            state ?? ''; // Assuming state is used for location

        // Set the selected gender based on the response
        if (gender != null) {
          if (gender!.toLowerCase() == 'male') {
            _selectedRadioValue = 1;
          } else if (gender!.toLowerCase() == 'female') {
            _selectedRadioValue = 2;
          } else {
            _selectedRadioValue = 3; // Other
          }
        }

        _isLoading = false; // Set loading to false after data is fetched
        notifyListeners();
        print("Profile Loaded: ${response.body}");
        print("Profile Image URL: $_profileImage");
      } else {
        print('Error fetching profile: ${response.statusCode}');

        _isLoading = false; // Set loading to false on error
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');

      _isLoading = false; // Set loading to false on exception
      notifyListeners();
    }
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
        _profileImage = pickedFile.path;
        notifyListeners();
      }
    }
  }
}
