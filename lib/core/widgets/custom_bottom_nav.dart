import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/navigation_controller.dart';

class CustomBottomNav extends StatelessWidget {
  final List<bool> hasNotification;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const CustomBottomNav(
      {super.key,
      required this.hasNotification,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final navController = Provider.of<NavigationController>(context);

    return BottomNavigationBar(
      items: [
        _buildNavItem('images/Home_active.png', 'Home', hasNotification[0]),
        _buildNavItem(
            'images/Categories.png', 'Categories', hasNotification[1]),
        _buildNavItem('images/Orders.png', 'Orders', hasNotification[2]),
        _buildNavItem('images/Profile.png', 'Profile', hasNotification[3]),
      ],
      currentIndex: navController.selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) =>
          navController.changeTab(index, context, onToggleDarkMode, isDarkMode),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String assetPath, String label, bool hasNotification) {
    return BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage(assetPath),
        color: Colors.grey,
      ),
      label: label,
      activeIcon: Stack(
        alignment: Alignment.center,
        children: [
          ImageIcon(AssetImage(assetPath)),
          if (hasNotification)
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
    );
  }
}
