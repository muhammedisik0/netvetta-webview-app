import 'package:flutter/material.dart';

import '../utils/globals.dart';

class SnackBarHelper {
  static void showErrorSnackBar(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );

    _show(snackBar);
  }

  static void showSuccessSnackBar(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );

    _show(snackBar);
  }

  static void _show(SnackBar snackBar) {
    final scaffoldMessengerState =
        ScaffoldMessenger.of(navigatorKey.currentContext!);
    if (scaffoldMessengerState.mounted) {
      scaffoldMessengerState.hideCurrentSnackBar();
    }
    scaffoldMessengerState.showSnackBar(snackBar);
  }
}
