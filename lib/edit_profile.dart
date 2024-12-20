import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final storage = const FlutterSecureStorage();
  int? _selectedRadioValue = 1;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  String? profileImg;
  String phoneNumber = '';
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final double maxWidth = 360;
  final double maxHeight = 360;

  Future<void> _selectImage() async {
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
          setState(() {
            profileImg = croppedImage.path;
          });
        }
      } else {
        // Image is within the specified resolution, no need to crop
        setState(() {
          profileImg = pickedFile.path;
        });
      }
    }
  }

  void _showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('Edit Profile',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
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
                              if (profileImg == null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Container(
                                    width: (85 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (85 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey,
                                    child: Image.asset(
                                      'images/Profile.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else if (profileImg != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Container(
                                    width: (85 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (85 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey,
                                    child: Image.file(
                                      File(profileImg!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    _selectImage();
                                  },
                                  child: Image.asset(
                                    height: 30,
                                    'images/profile_edit.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                phoneNumber = phone
                                    .completeNumber; // Store the phone number
                              });
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ${country.name}');
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: _locationController,
                            focusNode: _locationFocusNode,
                            style: const TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Location',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.onSurface,
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
                          child: Row(
                            children: [
                              filter('Male', 1),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              filter('Female', 2),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              filter('Other', 3)
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                (28.0 / MediaQuery.of(context).size.height) *
                                    MediaQuery.of(context).size.height),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: (60 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.white;
                                    }
                                    return const Color(0xFF1D4ED8);
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0xFF1D4ED8);
                                    }
                                    return Colors.white;
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
                                shape: WidgetStateProperty.resolveWith<
                                    RoundedRectangleBorder>(
                                  (Set<WidgetState> states) {
                                    return const RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 3,
                                        color: Color(0xFF1D4ED8),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    );
                                  },
                                ),
                              ),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
      ),
    );
  }

  Widget filter(String text, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRadioValue = value; // Update selected value
          });
        },
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.0),
                border: Border.all(
                  width: _selectedRadioValue == value ? 3 : 0.8,
                  color: _selectedRadioValue == value
                      ? const Color(0xFF1D4ED8)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
