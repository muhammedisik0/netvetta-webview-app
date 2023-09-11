// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:netvetta/constants/uri_constants.dart';

import 'package:netvetta/widgets/custom_button.dart';
import 'package:netvetta/widgets/social_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/color_constants.dart';
import '../constants/enum_constants.dart';
import '../constants/message_constants.dart';
import '../constants/route_constants.dart';
import '../helpers/snackbar_helper.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get phoneNumber => phoneNumberController.text.trim();
  String get password => passwordController.text.trim();

  void onLoginButtonPressed() {
    checkIfAnyInputFieldBlank();
    checkLoginStatus();
  }

  Future<void> onSignUpButtonPressed() async {
    final uri = Uri.parse(UriConstants.signUp);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch!';
    }
  }

  void onWhatIsNetvettaButtonPressed() {}

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

  void checkIfAnyInputFieldBlank() {
    if (phoneNumber.isEmpty || password.isEmpty) {
      SnackBarHelper.showErrorSnackBar(
        context,
        MessageConstants.fillInTheRequiredFields,
      );
      return;
    }
  }

  Future<LoginSatus> get loginStatus async {
    final User user = User(
      kk: 'netvetta',
      phoneNumber: phoneNumber,
      password: password,
    );
    return await AuthService().login(user);
  }

  Future<void> checkLoginStatus() async {
    switch (await loginStatus) {
      case LoginSatus.success:
        saveToStorage(phoneNumber, password);
        await Navigator.pushReplacementNamed(
          context,
          RouteConstants.pages,
        );
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

  void saveToStorage(String phoneNumber, password) {
    StorageService.phoneNumber = phoneNumber;
    StorageService.password = password;
    StorageService.isLoggedIn = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Container(
            //color: Colors.red,
            child: Center(
              child: Column(
                children: [
                  Expanded(
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
                        const SizedBox(height: 10),
                        signUpButton,
                        const SizedBox(height: 20),
                        divider,
                        const SizedBox(height: 30),
                        whatIsNetvettaButton,
                      ],
                    ),
                  ),
                  socialButtons
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get netvettaLogo {
    return const Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NETVETTA',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),

        /*Icon(
          FontAwesomeIcons.gear,
          size: 24,
          color: Colors.black,
        ),
        SizedBox(width: 10),
        Text(
          'Netvetta',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: Colors.black,
          ),
        ),*/
      ],
    );
  }

  Widget get phoneNumberField {
    return CustomTextField(
      controller: phoneNumberController,
      hintText: '(502xxxxxxx)',
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
      color: const Color(0xff673AB7),
      height: 48,
    );
  }

  Divider get divider {
    return const Divider(
      color: Color(0xffCCCCCC),
      thickness: 1,
      height: 0,
    );
  }

  Widget get whatIsNetvettaButton {
    return CustomButton(
      onPressed: onWhatIsNetvettaButtonPressed,
      text: 'Netvetta Nedir?',
      color: const Color(0xff1565C0),
      height: 60,
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
