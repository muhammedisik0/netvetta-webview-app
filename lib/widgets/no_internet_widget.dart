import 'package:flutter/material.dart';

import '../constants/message_constants.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Icon(
            Icons.wifi_off_rounded,
            size: 180,
            color: Color(0xffE4A11B),
          ),
          SizedBox(height: 20),
          Text(
            MessageConstants.checkYourInternetConnection,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
