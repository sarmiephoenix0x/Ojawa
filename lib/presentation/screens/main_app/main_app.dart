import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_back_handler.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../../../core/widgets/logout_dialog.dart';
import '../../../main.dart';
import '../../controllers/main_app_controllers.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/notification_controller.dart';
import '../categories_page/categories_page.dart';
import '../home_page/home_page.dart';
import '../orders_page/orders_page.dart';
import '../products_page/products_page.dart';
import '../profile_page/profile_page.dart';
import 'widgets/drawer.dart';

class MainApp extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const MainApp(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final navController = Provider.of<NavigationController>(context);
    //final mainAppController = Provider.of<MainAppControllers>(context);
    final notificationController = Provider.of<NotificationController>(context);
    return ChangeNotifierProvider(
      create: (context) => MainAppControllers(
          onToggleDarkMode: widget.onToggleDarkMode,
          isDarkMode: widget.isDarkMode),
      child: Consumer<MainAppControllers>(
          builder: (context, mainAppController, child) {
        return CustomBackHandler(
          child: Scaffold(
            key: scaffoldKey,
            // drawer: MainAppDrawer(
            //   goToCategoriesPage: mainAppController.goToCategoriesPage,
            //   goToOrdersPage: mainAppController.goToOrdersPage,
            //   showLogoutDialog: (context) => showLogoutDialog(
            //       context,
            //       (context) => mainAppController.logoutCall(
            //           context, widget.onToggleDarkMode, widget.isDarkMode)),
            //   profileImage: mainAppController.profileImage,
            //   userName: mainAppController.userName,
            //   phone: mainAppController.phone,
            //   checkForToken: mainAppController.checkForToken,
            //   goToProfilePage: mainAppController.goToProfilePage,
            //   onToggleDarkMode: widget.onToggleDarkMode,
            //   isDarkMode: widget.isDarkMode,
            // ),
            body: SafeArea(
              child: IndexedStack(
                index: navController.selectedIndex,
                children: [
                  HomePage(
                    selectedIndex: mainAppController.selectedIndex,
                    onToggleDarkMode: widget.onToggleDarkMode,
                    isDarkMode: widget.isDarkMode,
                    goToCategoriesPage: mainAppController.goToCategoriesPage,
                    goToOrdersPage: mainAppController.goToOrdersPage,
                    goToProfilePage: mainAppController.goToProfilePage,
                    // scaffoldKey: scaffoldKey,
                  ),
                  // CategoriesPage(
                  //   goToCategoriesPage: mainAppController.goToCategoriesPage,
                  //   goToOrdersPage: mainAppController.goToOrdersPage,
                  //   goToProfilePage: mainAppController.goToProfilePage,
                  //   // scaffoldKey: scaffoldKey,
                  //   selectedImageIndex: mainAppController.selectedImageIndex,
                  //   onToggleDarkMode: widget.onToggleDarkMode,
                  //   isDarkMode: widget.isDarkMode,
                  // ),
                  OrdersPage(
                      goToCategoriesPage: mainAppController.goToCategoriesPage,
                      goToOrdersPage: mainAppController.goToOrdersPage,
                      goToProfilePage: mainAppController.goToProfilePage,
                      // scaffoldKey: scaffoldKey,
                      onToggleDarkMode: widget.onToggleDarkMode,
                      isDarkMode: widget.isDarkMode),
                  ProductsPage(
                    goToCategoriesPage: mainAppController.goToCategoriesPage,
                    goToOrdersPage: mainAppController.goToOrdersPage,
                    goToProfilePage: mainAppController.goToProfilePage,
                    // scaffoldKey: scaffoldKey,
                    selectedImageIndex: mainAppController.selectedImageIndex,
                    onToggleDarkMode: widget.onToggleDarkMode,
                    isDarkMode: widget.isDarkMode,
                  ),
                  ProfilePage(
                    goToCategoriesPage: mainAppController.goToCategoriesPage,
                    goToOrdersPage: mainAppController.goToOrdersPage,
                    goToProfilePage: mainAppController.goToProfilePage,
                    onToggleDarkMode: widget.onToggleDarkMode,
                    isDarkMode: widget.isDarkMode,
                    // scaffoldKey: scaffoldKey,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: CustomBottomNav(
                hasNotification: notificationController.hasNotificationList,
                onToggleDarkMode: widget.onToggleDarkMode,
                isDarkMode: widget.isDarkMode),
          ),
        );
      }),
    );
  }
}
