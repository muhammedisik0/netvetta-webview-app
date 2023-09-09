// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../constants/enum_constants.dart';
import '../constants/message_constants.dart';
import '../helpers/snackbar_helper.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_textfield_widget.dart';
import 'pages_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //bool isLoginButtonPressed = false;

  bool get isAnyInputFieldBlank {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onLoginButtonPressed() async {
    //print('--------PRESSED---------');
    if (isAnyInputFieldBlank) {
      SnackBarHelper.showErrorSnackBar(
        context,
        MessageConstants.fillInTheRequiredFields,
      );
      return;
    }

    final String phoneNumber = phoneController.text.trim();
    final String password = passwordController.text.trim();

    final User user = User(
      kk: 'netvetta',
      phoneNumber: phoneNumber,
      password: password,
    );

    final loginStatus = await AuthService().login(user);

    switch (loginStatus) {
      case LoginSatus.success:
        //setState(() => isLoginButtonPressed = true);
        saveToStorage(phoneNumber, password);
        await navigateToPagesScreen();
        SnackBarHelper.showSuccessSnackBar(
          context,
          MessageConstants.loggedInSuccessfully,
        );
        break;
      case LoginSatus.fail:
        SnackBarHelper.showErrorSnackBar(
          context,
          MessageConstants.incorrectCredentials,
        );
        break;
      case LoginSatus.error:
        SnackBarHelper.showErrorSnackBar(
          context,
          MessageConstants.anErrorOccured,
        );
        break;
      case LoginSatus.exception:
        SnackBarHelper.showErrorSnackBar(
          context,
          MessageConstants.anErrorOccured,
        );
        break;
    }
  }

  Future<void> navigateToPagesScreen() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PagesScreen(),
      ),
    );
  }

  void saveToStorage(String phoneNumber, password) {
    StorageService.phoneNumber = phoneNumber;
    StorageService.password = password;
    StorageService.isLoggedIn = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body),
    );
  }

  Widget get body {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          netvettaLogo,
          const SizedBox(height: 40),
          phoneNumberField,
          const SizedBox(height: 20),
          passwordField,
          const SizedBox(height: 20),
          loginButton,
        ],
      ),
    );
  }

  Widget get netvettaLogo {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.settings,
          size: 32,
          color: Color(0xff2A3F54),
        ),
        SizedBox(width: 10),
        Text(
          'Netvetta',
          style: TextStyle(
            color: Color(0xff2A3F54),
            fontWeight: FontWeight.w500,
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  Widget get phoneNumberField {
    return CustomTextField(
      controller: phoneController,
      hintText: 'Cep Telefonu',
      obscureText: false,
      inputAction: TextInputAction.next,
      //maxLength: 10,
    );
  }

  Widget get passwordField {
    return CustomTextField(
      controller: passwordController,
      hintText: 'Şifre',
      obscureText: true,
      inputAction: TextInputAction.done,
      //maxLength: 4,
    );
  }

  Widget get loginButton {
    return MaterialButton(
      //onPressed: isLoginButtonPressed ? () {} : onLoginButtonPressed,
      onPressed: onLoginButtonPressed,
      minWidth: double.infinity,
      height: 48,
      color: const Color(0xff2A3F54),
      child: const Text(
        'Giriş',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
