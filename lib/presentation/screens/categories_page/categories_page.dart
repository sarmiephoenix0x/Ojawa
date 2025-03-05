import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/categories_page_controller.dart';
import '../categories_details/categories_details.dart';

class CategoriesPage extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  // final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedImageIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const CategoriesPage(
      {super.key,
      required this.goToCategoriesPage,
      required this.goToOrdersPage,
      required this.goToProfilePage,
      // required this.scaffoldKey,
      required this.selectedImageIndex,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final categoriesPageController =
    //     Provider.of<CategoriesPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => CategoriesPageController(
          mainSelectedImageIndex: widget.selectedImageIndex),
      child: Consumer<CategoriesPageController>(
          builder: (context, categoriesPageController, child) {
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
                            // widget.scaffoldKey.currentState?.openDrawer();
                            setState(() {
                              categoriesPageController.setIsSidebarOpen(
                                  !categoriesPageController.isSidebarOpen);
                            });
                          },
                        ),
                        const Text('Categories',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  // Main content area
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                          top: 20.0,
                          left: categoriesPageController.isSidebarOpen
                              ? 120.0
                              : 8.0,
                          right: 8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        childAspectRatio: categoriesPageController.isSidebarOpen
                            ? 0.6
                            : 1, // Aspect ratio of each item
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
                                    builder: (context) => CategoriesDetails(
                                      key: UniqueKey(),
                                      onToggleDarkMode: widget.onToggleDarkMode,
                                      isDarkMode: widget.isDarkMode,
                                    ),
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
                                      image: AssetImage(categoriesPageController
                                          .getImageUrl2(index %
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
                                categoriesPageController.getImageLabel2(index %
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
                left: categoriesPageController.isSidebarOpen ? 0 : -250,
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
                            categoriesPageController
                                .setSelectedImageIndex(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Indicator on the right side
                              if (categoriesPageController.selectedImageIndex ==
                                  index)
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
                                      categoriesPageController
                                          .getImageUrl(index),
                                      height: 70,
                                    ),
                                    const SizedBox(
                                        height:
                                            4), // Space between image and text
                                    Text(
                                      categoriesPageController
                                          .getImageLabel(index),
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
      }),
    );
  }
}
