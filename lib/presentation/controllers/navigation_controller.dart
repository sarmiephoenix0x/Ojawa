import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth/sign_in_page.dart';
import 'main_app_controllers.dart';

class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeTab(int index, BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    if (index != _selectedIndex) {
      if (index != 3) {
        _selectedIndex = index;
        notifyListeners();
      } else {
        bool tokenExists =
            await Provider.of<MainAppControllers>(context, listen: false)
                .checkForToken();

        if (!tokenExists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignInPage(
                  key: UniqueKey(),
                  onToggleDarkMode: onToggleDarkMode,
                  isDarkMode: isDarkMode),
            ),
          );
        } else {
          _selectedIndex = index;
          notifyListeners();
        }
      }
    }
  }
}
