import 'dart:async';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../constants/enum_constants.dart';
import '../models/user_model.dart';

class AuthService {
  Future<LoginSatus> logIn(User user) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginUrl),
        body: user.toJson(),
      );
      if (response.statusCode == 200) {
        return response.body == 'error' ? LoginSatus.fail : LoginSatus.success;
      } else {
        return LoginSatus.error;
      }
    } catch (e) {
      return LoginSatus.exception;
    }
  }
}
