import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToLoginOrPagesScreen();
  }

  Future<void> navigateToLoginOrPagesScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(
      context,
      StorageService.isLoggedIn ? RouteConstants.pages : RouteConstants.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app-logo.png',
              width: 240,
            ),
            /*Icon(
              FontAwesomeIcons.gear,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Netvetta',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 36,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
