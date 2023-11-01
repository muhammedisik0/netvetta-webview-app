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
    appLogo = Image.asset('assets/images/app-logo.png', width: 240);
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
      color: ColorConstants.primaryColor,
      child: Center(child: appLogo),
    );
  }
}
