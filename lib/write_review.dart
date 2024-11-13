import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({super.key});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  int _starCount = 5;
  List<String> _imageUrl = [];
  final ImagePicker _picker = ImagePicker();
  final double maxWidth = 360;
  final double maxHeight = 360;
  bool isLoading = false;

  Future<void> _pickImage() async {
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
            if (_imageUrl.length < 3) {
              _imageUrl.add(croppedImage.path);
            } else {
              // Optionally, show a snackbar or alert that max images reached
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Max 3 images allowed')),
              );
            }
          });
        }
      } else {
        // Image is within the specified resolution, no need to crop
        setState(() {
          if (_imageUrl.length < 3) {
            _imageUrl.add(pickedFile.path);
          } else {
            // Optionally, show a snackbar or alert that max images reached
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Max 3 images allowed')),
            );
          }
        });
      }
    }
  }

  void _submitReview() {
    // Logic to submit the review
  }

  Widget _buildStarRating(int starCount) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _starCount = index + 1;
            });
          },
          child: Icon(
            index < starCount ? Icons.star : Icons.star_border,
            color: index < starCount ? Colors.yellow : Colors.grey,
            size: 28.0,
          ),
        );
      }),
    );
  }

  void _submittedReview() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/Tick.png', // Replace with the item's image asset or network path
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(
                height: (28 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            const Center(
              child: Text(
                'Review Submitted Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
                height: (28 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),
            Container(
              width: double.infinity,
              height: (60 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return const Color(0xFF1D4ED8);
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF1D4ED8);
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
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Write Re-view',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image and name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/Img2.png', // Replace with the item's image asset or network path
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                    width: (16.0 / MediaQuery.of(context).size.width) *
                        MediaQuery.of(context).size.width),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calvin Clein Regular fit slim fit shirt',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: (10.0 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height),
                      _buildStarRating(_starCount),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
                height: (16.0 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),

            // Title of Review
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Heading of your review',
                border: OutlineInputBorder(),
                hintText: 'Enter the title of your review',
              ),
              maxLength: 50,
            ),
            SizedBox(
                height: (16.0 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),

            // Review Content
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
                hintText: 'Write your detailed review here',
              ),
              maxLines: 4,
            ),
            SizedBox(
                height: (16.0 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),

            // Add Photo Button
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'images/AddPhoto.png', // Replace with your asset image path
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                          height: (4.0 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height),
                      const Text(
                        "Add Photo",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontFamily:
                              'Poppins', // Optional: match your app's style
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: (8.0 / MediaQuery.of(context).size.width) *
                        MediaQuery.of(context).size.width),
                // Display selected images
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageUrl.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_imageUrl[index]),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: (24.0 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height),

            Container(
              width: double.infinity,
              height: (60 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: ElevatedButton(
                onPressed: () {
                  _submittedReview();
                  // if (_titleController.text.trim().isNotEmpty &&
                  //     _reviewController.text.trim().isNotEmpty) {
                  //   _submitReview();
                  // }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (_titleController.text.trim().isNotEmpty &&
                          _reviewController.text.trim().isNotEmpty) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white;
                        }
                        return const Color(0xFF1D4ED8);
                      } else {
                        return Colors.grey;
                      }
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (_titleController.text.trim().isNotEmpty &&
                          _reviewController.text.trim().isNotEmpty) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF1D4ED8);
                        }
                        return Colors.white;
                      } else {
                        return Colors.white;
                      }
                    },
                  ),
                  elevation: WidgetStateProperty.all<double>(4.0),
                  shape:
                      WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<WidgetState> states) {
                      final bool isFilled =
                          _titleController.text.trim().isNotEmpty &&
                              _reviewController.text.trim().isNotEmpty;

                      return RoundedRectangleBorder(
                        side: BorderSide(
                          width: 3,
                          color:
                              isFilled ? const Color(0xFF1D4ED8) : Colors.grey,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
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
                        'Submit Review',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
