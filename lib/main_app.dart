import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class MainApp extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const MainApp(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<bool> _hasNotification = [false, false, false, false];
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
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
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            _showCustomSnackBar(
              context,
              'Press back again to exit',
              isError: true,
            );
          } else {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: _buildPageContent(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Home_active.png'),
                color: Colors.grey,
              ),
              label: '',
              // Add notification dot
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Home_active.png')),
                  if (_hasNotification[0])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Categories.png'),
                color: Colors.grey,
              ),
              label: '',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Categories.png')),
                  if (_hasNotification[1])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Orders.png'),
                color: Colors.grey,
              ),
              label: '',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Orders.png')),
                  if (_hasNotification[2])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage('images/Profile.png'),
                color: Colors.grey,
              ),
              label: '',
              activeIcon: Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(AssetImage('images/Profile.png')),
                  if (_hasNotification[3])
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                ],
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          // Customize the selected item color
          onTap: (index) {
            if (index != _selectedIndex) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return HomePage(
            selectedIndex: _selectedIndex,
            onToggleDarkMode: widget.onToggleDarkMode,
            isDarkMode: widget.isDarkMode);
      case 1:
      // return SearchPage(
      //   selectedIndex: _selectedIndex,
      // );
      case 2:
      // return LikePage(
      //   selectedIndex: _selectedIndex,
      // );
      case 3:
      // return ExplorePage(
      //   selectedIndex: _selectedIndex,
      // );
      case 4:
      // return AccountPage(
      //     selectedIndex: _selectedIndex,
      //     onToggleDarkMode: widget.onToggleDarkMode,
      //     isDarkMode: widget.isDarkMode);
      default:
        return const Center(child: Text("Error: Invalid page index"));
    }
  }
}
