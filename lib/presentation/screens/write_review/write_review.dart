import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../controllers/write_review_controller.dart';
import 'widgets/star_rating.dart';

class WriteReviewPage extends StatefulWidget {
  final int productId;
  final String productImg;
  final int rating;
  const WriteReviewPage(
      {super.key,
      required this.productId,
      required this.productImg,
      required this.rating});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final writeReviewController = Provider.of<WriteReviewController>(context);
    return ChangeNotifierProvider(
      create: (context) => WriteReviewController(rating: widget.rating),
      child: Consumer<WriteReviewController>(
          builder: (context, writeReviewController, child) {
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
                    Image.network(
                      widget.productImg,
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
                              height:
                                  (10.0 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height),
                          StarRating(
                              starCount: writeReviewController.starCount),
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
                  controller: writeReviewController.titleController,
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
                  controller: writeReviewController.reviewController,
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
                      onTap: writeReviewController.pickImage,
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
                              height:
                                  (4.0 / MediaQuery.of(context).size.height) *
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
                          itemCount: writeReviewController.imageUrl.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(writeReviewController.imageUrl[index]),
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
                      if (writeReviewController.titleController.text
                              .trim()
                              .isNotEmpty &&
                          writeReviewController.reviewController.text
                              .trim()
                              .isNotEmpty) {
                        writeReviewController.submitFeedback(
                            context, widget.productId);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (writeReviewController.titleController.text
                                  .trim()
                                  .isNotEmpty &&
                              writeReviewController.reviewController.text
                                  .trim()
                                  .isNotEmpty) {
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
                          if (writeReviewController.titleController.text
                                  .trim()
                                  .isNotEmpty &&
                              writeReviewController.reviewController.text
                                  .trim()
                                  .isNotEmpty) {
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
                      shape: WidgetStateProperty.resolveWith<
                          RoundedRectangleBorder>(
                        (Set<WidgetState> states) {
                          final bool isFilled = writeReviewController
                                  .titleController.text
                                  .trim()
                                  .isNotEmpty &&
                              writeReviewController.reviewController.text
                                  .trim()
                                  .isNotEmpty;

                          return RoundedRectangleBorder(
                            side: BorderSide(
                              width: 3,
                              color: isFilled
                                  ? const Color(0xFF1D4ED8)
                                  : Colors.grey,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          );
                        },
                      ),
                    ),
                    child: writeReviewController.isLoading
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
      }),
    );
  }
}
