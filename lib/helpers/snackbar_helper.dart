import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showErrorSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'Giriş bilgileri yanlış, tekrar deneyin!',
        style: TextStyle(fontSize: 16),
      ),
    );

    show(context, snackBar);
  }

  static void showSuccessSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'Başarılı bir şekide giriş yaptın!',
        style: TextStyle(fontSize: 16),
      ),
    );

    show(context, snackBar);
  }

  static void show(BuildContext context, SnackBar snackBar) {
    final scaffoldMessengerState = ScaffoldMessenger.of(context);
    if (scaffoldMessengerState.mounted) scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(snackBar);
  }
}
