// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/globals.dart';
import '../constants/enum_constants.dart';
import '../constants/message_constants.dart';
import '../constants/route_constants.dart';
import '../constants/uri_constants.dart';
import '../helpers/snackbar_helper.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield_widget.dart';
import '../widgets/no_internet_widget.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final connectivityService = ConnectivityService();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool hasInternet = true;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkInternetOnInit();
    connectivitySubscription =
        connectivityService.connectivityStream.listen(onResult);
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> checkInternetOnInit() async {
    final result = await connectivityService.connectivityResult;
    final value = connectivityService.hasInternet(result);
    if (!value) setState(() => hasInternet = value);
  }

  void onResult(ConnectivityResult result) {
    final value = connectivityService.hasInternet(result);
    setState(() => hasInternet = value);
  }

  String get phoneNumber => phoneNumberController.text.trim();

  String get password => passwordController.text.trim();

  Future<void> onLoginButtonPressed() async {
    if (phoneNumber.isEmpty || password.isEmpty) {
      SnackBarHelper.showErrorSnackBar(
        MessageConstants.fillInTheRequiredFields,
      );
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );

    final value = await loginStatus;
    Navigator.of(context).pop();
    checkLoginStatus(value);
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

  Future<LoginSatus> get loginStatus async {
    final User user = User(
      kk: 'netvetta',
      phoneNumber: phoneNumber,
      password: password,
    );
    return await AuthService().login(user);
  }

  Future<void> checkLoginStatus(LoginSatus value) async {
    switch (value) {
      case LoginSatus.success:
        await saveToStorage(phoneNumber, password);
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

  Future<void> saveToStorage(String phoneNumber, password) async {
    await Future.wait([
      StorageService.setPhoneNumber(phoneNumber),
      StorageService.setPassword(password),
      StorageService.setIsLoggedIn(true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: hasInternet ? onlineWidget : offlineWidget,
      ),
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
    );
  }

  Widget get offlineWidget => const NoInternetWidget();

  Widget get netvettaLogo {
    return const Text(
      'NETVETTA',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 28,
        color: Colors.black,
        letterSpacing: 1.2,
      ),
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
      color: const Color(0xffff8000),
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
