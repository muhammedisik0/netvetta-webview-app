import 'package:flutter/material.dart';
import 'package:netvetta/screens/pages_screen.dart';
import 'package:netvetta/screens/login_screen.dart';
import 'package:netvetta/services/local_storage_service.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocalStorageService.isLoggedIn ? const PagesScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2A3F54),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/gear.png',
              width: 36,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text(
              'Netvetta',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
