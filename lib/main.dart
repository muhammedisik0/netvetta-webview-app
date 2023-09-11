import 'package:flutter/material.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import 'constants/route_constants.dart';
import 'screens/login_screen.dart';
import 'screens/pages_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetSecureStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteConstants.splash,
      routes: {
        RouteConstants.splash: (context) => const SplashScreen(),
        RouteConstants.login: (context) => const LoginScreen(),
        RouteConstants.pages: (context) => const PagesScreen(),
      },
    );
  }
}
