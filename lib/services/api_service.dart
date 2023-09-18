import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/notification_model.dart';

class ApiService {
  Future<List?> fetchNotifications() async {
    try {
      final url = Uri.parse(ApiConstants.notificationUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final listOfNotifications =
            jsonData.map((e) => INotification.fromJson(e)).toList();
        return listOfNotifications;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
