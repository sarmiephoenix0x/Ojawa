import 'package:flutter/material.dart';
import 'package:ojawa/categories_details.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _isSidebarOpen = false;
  int _selectedImageIndex = 0;

  String _getImageUrl(int index) {
    switch (index) {
      case 0:
        return 'images/Fashion.png';
      case 1:
        return 'images/Electronics.png';
      case 2:
        return 'images/Appliances.png';
      case 3:
        return 'images/Beauty.png';
      case 4:
        return 'images/Furniture.png';
      default:
        return '';
    }
  }

  String _getImageLabel(int index) {
    switch (index) {
      case 0:
        return 'Fashion';
      case 1:
        return 'Electronics';
      case 2:
        return 'Appliances';
      case 3:
        return 'Beauty';
      case 4:
        return 'Furniture';
      default:
        return '';
    }
  }

  String _getImageUrl2(int index) {
    switch (index) {
      case 0:
        return 'images/Img4.png';
      case 1:
        return 'images/Img5.png';
      case 2:
        return 'images/Img6.png';
      default:
        return '';
    }
  }

  String _getImageLabel2(int index) {
    switch (index) {
      case 0:
        return "Men's";
      case 1:
        return "Women's";
      case 2:
        return 'Kids';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              Container(
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
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          _isSidebarOpen = !_isSidebarOpen;
                        });
                      },
                    ),
                    const Text('Categories', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              // Main content area
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    childAspectRatio: 1, // Aspect ratio of each item
                    crossAxisSpacing: 8.0, // Space between columns
                    mainAxisSpacing: 8.0, // Space between rows
                  ),
                  itemCount:
                      3, // Total number of images/items you want to display
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoriesDetails(key: UniqueKey()),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Rounded edges for the card
                            ),
                            elevation: 4, // Shadow effect
                            child: Container(
                              // Use a Container to set the height and width of the image
                              height: 120, // Set the height of the image
                              width: double
                                  .infinity, // Make the image take the full width
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15), // Ensure the image respects the card's shape
                                image: DecorationImage(
                                  image: AssetImage(_getImageUrl2(index %
                                      5)), // Use modulo to cycle through your images
                                  fit: BoxFit
                                      .cover, // Fit the image within the container
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 4), // Space between card and text
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Padding around the text
                          child: Text(
                            _getImageLabel2(index %
                                5), // Use modulo to cycle through your labels
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // Sidebar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isSidebarOpen ? 0 : -250,
            top: 80,
            bottom: 0,
            child: Container(
              width: 110,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Indicator on the right side
                          if (_selectedImageIndex == index)
                            Container(
                              width: 5,
                              height: 70,
                              color: const Color(0xFF1FC5B1),
                            ),
                          // Column for image and text
                          Expanded(
                            child: Column(
                              children: [
                                Image.asset(
                                  _getImageUrl(index),
                                  height: 70,
                                ),
                                const SizedBox(
                                    height: 4), // Space between image and text
                                Text(
                                  _getImageLabel(index),
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
