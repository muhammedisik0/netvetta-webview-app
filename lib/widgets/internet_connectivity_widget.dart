import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../utils/globals.dart';
import 'no_internet_widget.dart';
import '../services/connectivity_service.dart';

class InternetConnectivityWidget extends StatefulWidget {
  const InternetConnectivityWidget({super.key, required this.online});

  final Widget online;

  @override
  State<InternetConnectivityWidget> createState() =>
      _InternetConnectivityWidgetState();
}

class _InternetConnectivityWidgetState
    extends State<InternetConnectivityWidget> {
  final connectivityService = ConnectivityService();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool hasInternet = true;

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
    internetNotifier.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return hasInternet ? widget.online : const NoInternetWidget();
  }
}
