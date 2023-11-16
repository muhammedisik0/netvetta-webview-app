import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netvetta/constants/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/globals.dart';
import '../constants/enum_constants.dart';
import '../constants/message_constants.dart';
import '../constants/route_constants.dart';
import '../constants/uri_constants.dart';
import '../helpers/snackbar_helper.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield_widget.dart';
import '../widgets/internet_connectivity_widget.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController userCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get userCode => userCodeController.text.trim();
  String get phoneNumber => phoneNumberController.text.trim();
  String get password => passwordController.text.trim();

  Future<void> onLoginButtonPressed() async {
    if (userCode.isEmpty || phoneNumber.isEmpty || password.isEmpty) {
      SnackBarHelper.showErrorSnackBar(
        MessageConstants.fillInTheRequiredFields,
      );
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );

    final status = await loginStatus;
    Navigator.of(navigatorKey.currentContext!).pop();
    checkLoginStatus(status);
  }

  void onSignUpButtonPressed() {
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      RouteConstants.signUp,
    );
  }

  Future<void> onInstagramButtonPressed() async {
    final uri = Uri.parse(UriConstants.instagram);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch!';
    }
  }

  Future<void> onFacebookButtonPressed() async {
    final uri = Uri.parse(UriConstants.facebook);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch!';
    }
  }

  Future<LoginSatus> get loginStatus async {
    final user = User(
      kk: userCode,
      phoneNumber: phoneNumber,
      password: password,
    );
    return AuthService().logIn(user);
  }

  Future<void> checkLoginStatus(LoginSatus status) async {
    switch (status) {
      case LoginSatus.success:
        await storeUserDataLocally();
        SnackBarHelper.showSuccessSnackBar(
          MessageConstants.loggedInSuccessfully,
        );
        Navigator.pushReplacementNamed(
          navigatorKey.currentContext!,
          RouteConstants.pages,
        );
        break;
      case LoginSatus.fail:
        SnackBarHelper.showErrorSnackBar(
          MessageConstants.incorrectCredentials,
        );
        break;
      case LoginSatus.error:
        SnackBarHelper.showErrorSnackBar(
          MessageConstants.anErrorOccured,
        );
        break;
      case LoginSatus.exception:
        SnackBarHelper.showErrorSnackBar(
          MessageConstants.anErrorOccured,
        );
        break;
    }
  }

  Future<void> storeUserDataLocally() async {
    Future.wait([
      StorageService.setUserCode(userCode),
      StorageService.setPhoneNumber(phoneNumber),
      StorageService.setPassword(password),
      StorageService.setIsLoggedIn(true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: InternetConnectivityWidget(online: onlineWidget)),
    );
  }

  Widget get onlineWidget {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                netvettaText,
                const SizedBox(height: 40),
                userCodeField,
                const SizedBox(height: 20),
                phoneNumberField,
                const SizedBox(height: 20),
                passwordField,
                const SizedBox(height: 20),
                loginButton,
                const SizedBox(height: 10),
                signUpButton,
              ],
            ),
          ),
          socialButtons
        ],
      ),
    );
  }

  Widget get netvettaText {
    return const Text(
      'Netvetta Mağazam',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget get userCodeField {
    return CustomTextField(
      controller: userCodeController,
      hintText: 'Kullanıcı Kodu',
      inputAction: TextInputAction.next,
    );
  }

  Widget get phoneNumberField {
    return CustomTextField(
      controller: phoneNumberController,
      hintText: '(502xxxxxxx)',
      inputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
    );
  }

  Widget get passwordField {
    return CustomTextField(
      controller: passwordController,
      hintText: 'Şifre',
      obscureText: true,
      inputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
    );
  }

  Widget get loginButton {
    return CustomButton(
      onPressed: onLoginButtonPressed,
      text: 'Giriş',
      color: const Color(0xff009688),
      height: 48,
    );
  }

  Widget get signUpButton {
    return CustomButton(
      onPressed: onSignUpButtonPressed,
      text: 'Üye Ol',
      color: const Color(0xffff8000),
      height: 48,
    );
  }

  Widget get socialButtons {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          onPressed: onInstagramButtonPressed,
          icon: FontAwesomeIcons.instagram,
          color: const Color(0xffc2185b),
        ),
        const SizedBox(width: 20),
        SocialButton(
          onPressed: onFacebookButtonPressed,
          icon: FontAwesomeIcons.facebook,
          color: const Color(0xff1877F2),
        ),
      ],
    );
  }
}
