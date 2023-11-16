import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Image appLogo;

  @override
  void initState() {
    super.initState();
    const String appIcon = 'assets/icons/app_icon.png';
    appLogo = Image.asset(appIcon, width: 240);
    final route =
        StorageService.isLoggedIn ? RouteConstants.pages : RouteConstants.login;
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(appLogo.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.slateBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appLogo,
          netvettaMagazamText,
        ],
      ),
    );
  }

  Widget get netvettaMagazamText {
    return const SizedBox(
      width: 160,
      child: FittedBox(
        child: Text(
          'NETVETTA\nMAĞAZAM',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ColorConstants.goldenYellow,
            letterSpacing: 1.2,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
