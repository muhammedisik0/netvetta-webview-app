import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showErrorSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );

    show(context, snackBar);
  }

  static void showSuccessSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );

    show(context, snackBar);
  }

  static void showWarningSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: const Color(0xffE4A11B),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );

    show(context, snackBar);
  }

  static void show(BuildContext context, SnackBar snackBar) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    if (scaffoldMessengerState.mounted) {
      scaffoldMessengerState.hideCurrentSnackBar();
    }
    scaffoldMessengerState.showSnackBar(snackBar);
  }
}
