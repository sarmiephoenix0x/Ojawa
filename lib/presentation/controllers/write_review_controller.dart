import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/write_review/widgets/bottom_sheets/write_review_submitted_sheet.dart';

class WriteReviewController extends ChangeNotifier {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  int _starCount = 5;
  List<String> _imageUrl = [];
  final ImagePicker _picker = ImagePicker();
  final double maxWidth = 360;
  final double maxHeight = 360;
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();

  final int rating;

  WriteReviewController({required this.rating}) {
    initialize();
  }

  //public getters
  int get starCount => _starCount;
  bool get isLoading => _isLoading;
  List<String> get imageUrl => _imageUrl;

  TextEditingController get titleController => _titleController;
  TextEditingController get reviewController => _reviewController;

  void initialize() {
    _starCount = rating;
  }

  void setStarCount(int value) {
    _starCount = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
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
          if (_imageUrl.length < 3) {
            _imageUrl.add(croppedImage.path);
          } else {
            // Optionally, show a snackbar or alert that max images reached

            CustomSnackbar.show(
              'Max 3 images allowed',
              isError: true,
            );
          }
          notifyListeners();
        }
      } else {
        // Image is within the specified resolution, no need to crop

        if (_imageUrl.length < 3) {
          _imageUrl.add(pickedFile.path);
        } else {
          // Optionally, show a snackbar or alert that max images reached
          CustomSnackbar.show(
            'Max 3 images allowed',
            isError: true,
          );
        }
        notifyListeners();
      }
    }
  }

  Future<void> submitFeedback(BuildContext context, int productId) async {
    if (_starCount == 0) {
      CustomSnackbar.show(
        'Please select a rating before submitting.',
        isError: true,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();
    final String _review = _reviewController.text.trim();
    final String _header = _titleController.text.trim();
    final String? accessToken = await storage.read(key: 'accessToken');
    final String apiUrl = "https://ojawa-api.onrender.com/api/Feedbacks";
    final Map<String, dynamic> feedbackData = {
      "productId": productId, // Replace with the actual product ID
      "rating": _starCount,
      "review": {
        "headline": _header,
        "body": _review,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(feedbackData),
      );

      if (response.statusCode == 200) {
        submittedReview(context);
      } else {
        CustomSnackbar.show(
          'Failed to submit review. Please try again.',
          isError: true,
        );
      }
    } catch (error) {
      print("An error occurred: $error");
      CustomSnackbar.show(
        'An error occurred',
        isError: true,
      );
    } finally {
      _isLoading = false; // Hide loading indicator
      notifyListeners();
    }
  }
}
