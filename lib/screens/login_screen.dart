import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netvetta/constants/api_constants.dart';
import 'package:netvetta/helpers/snackbar_helper.dart';
import 'package:netvetta/screens/pages_screen.dart';
import 'package:netvetta/screens/pages_screen.dart';
import 'package:netvetta/services/local_storage_service.dart';
import 'package:netvetta/widgets/custom_textfield_widget.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String correctPhoneNumber = '5325682383';
  String correctPassword = '1212';

  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    final String phoneNumber = phoneController.text.trim();
    final String password = passwordController.text.trim();

    if (phoneNumber == correctPhoneNumber && password == correctPassword) {
      SnackBarHelper.showSuccessSnackBar(context);
      LocalStorageService.phoneNumber = correctPhoneNumber;
      LocalStorageService.password = correctPassword;
      LocalStorageService.isLoggedIn = true;
      navigateToPagesScreen();
    } else {
      SnackBarHelper.showErrorSnackBar(context);
    }

    /*final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: {
        'user_phone': phoneNumber,
        'user_password': password,
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        // ignore: use_build_context_synchronously
        SnackBarHelper.showSuccessSnackbar(
          context,
          'Başarılı bir şekide giriş yaptın!',
        );
      } else {
        // ignore: use_build_context_synchronously
        SnackBarHelper.showErrorSnackbar(
          context,
          'Hata oluştu, tekrar deneyin!',
        );
      }
    }*/
  }

  Future<void> navigateToPagesScreen() async {
    //await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PagesScreen(),
      ),
    );
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/gear.png',
          width: 28,
          color: const Color(0xff2A3F54),
        ),
        const SizedBox(width: 10),
        const Text(
          'Netvetta',
          style: TextStyle(
            color: Color(0xff2A3F54),
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
      ],
    );
  }

  /*Widget get loginText {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Giriş',
        style: TextStyle(
          fontSize: 28,
        ),
      ),
    );
  }*/

  Widget get phoneNumberField {
    return CustomTextField(
      controller: phoneController,
      hintText: 'Cep Telefonu',
      obscureText: false,
      inputAction: TextInputAction.next,
    );
  }

  Widget get passwordField {
    return CustomTextField(
      controller: passwordController,
      hintText: 'Şifre',
      obscureText: true,
      inputAction: TextInputAction.done,
    );
  }

  Widget get loginButton {
    return MaterialButton(
      onPressed: login,
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
