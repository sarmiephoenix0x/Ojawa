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
  int _starCount = 0;
  List<String> _imageUrl = [];
  final ImagePicker _picker = ImagePicker();
  final double maxWidth = 360;
  final double maxHeight = 360;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/Img2.png', // Replace with the item's image asset or network path
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                const Expanded(
                  child: Text(
                    'Calvin Clein Regular fit slim fit shirt',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Star Rating
            _buildStarRating(_starCount),
            const SizedBox(height: 16.0),

            // Title of Review
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Review Title',
                border: OutlineInputBorder(),
                hintText: 'Enter the title of your review',
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16.0),

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
            const SizedBox(height: 16.0),

            // Add Photo Button
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.add_a_photo, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8.0),

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
                          child: Image.file(
                            File(_imageUrl[index]),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Submit Review Button
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    //  _submitReview();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                  ),
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(fontSize: 18.0),
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
