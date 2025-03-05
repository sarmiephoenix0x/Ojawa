import 'package:flutter/material.dart';

import '../../data/model/app_args.dart';
import '../../presentation/screens/auth/sign_in_page.dart';
import '../../presentation/screens/main_app/main_app.dart';

class AppRoutes {
  static const String signIn = '/sign-in';
  static const String mainApp = '/main-app';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        final args = settings.arguments as MainAppArgs;
        return MaterialPageRoute(
            builder: (_) => SignInPage(
                  key: UniqueKey(),
                  onToggleDarkMode: args.onToggleDarkMode,
                  isDarkMode: args.isDarkMode,
                ));

      case mainApp:
        final args = settings.arguments as MainAppArgs;
        return MaterialPageRoute(
          builder: (_) => MainApp(
            key: UniqueKey(),
            onToggleDarkMode: args.onToggleDarkMode,
            isDarkMode: args.isDarkMode,
          ),
        );

      default:
        final args = settings.arguments as MainAppArgs;
        return MaterialPageRoute(
            builder: (_) => SignInPage(
                  key: UniqueKey(),
                  onToggleDarkMode: args.onToggleDarkMode,
                  isDarkMode: args.isDarkMode,
                ));
    }
  }
}
