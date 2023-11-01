import 'package:flutter/material.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:netvetta/screens/sign_up_screen.dart';
import 'package:netvetta/utils/globals.dart';
import 'package:workmanager/workmanager.dart';

import 'services/notification_service.dart';
import 'constants/route_constants.dart';
import 'screens/login_screen.dart';
import 'screens/pages_screen.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'utils/function_utils.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await GetSecureStorage.init();
    await NotificationService().init();

    var listOfNotifications = await ApiService().fetchNotifications();
    if (listOfNotifications != null) {
      final latestNotfId = int.parse(StorageService.latestNotificationId);
      int difference = computeDifference(listOfNotifications, latestNotfId);
      listOfNotifications = listOfNotifications.sublist(0, difference);

      final userId = '${StorageService.userId}';
      for (var notification in listOfNotifications) {
        if (notification.cariId == userId || notification.cariId == '0') {
          NotificationService().showNotification(
            id: int.parse(notification.id),
            title: 'Netvetta',
            body: notification.content,
          );
        }
      }
      StorageService.latestNotificationId = listOfNotifications.first.id;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetSecureStorage.init();
  //await StorageService.clearStorage();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().cancelAll();
  Workmanager().registerPeriodicTask(
    DateTime.now().toString(),
    'Show Notification',
    frequency: const Duration(minutes: 15),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: RouteConstants.initialRoute,
      routes: {
        RouteConstants.initialRoute: (context) => const SplashScreen(),
        RouteConstants.login: (context) => LoginScreen(),
        RouteConstants.signUp: (context) => const SignUpScreen(),
        RouteConstants.pages: (context) => const PagesScreen(),
      },
    );
  }
}
