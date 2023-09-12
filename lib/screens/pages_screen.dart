import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../constants/uri_constants.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';
import '../utils/url_utils.dart';
import '../widgets/bottom_navbar_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/no_internet_widget.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  final connectivityService = ConnectivityService();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool hasInternet = true;

  late final WebViewController webViewController;
  int currentIndex = 0;
  bool isLoading = true;
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = StorageService.userId;

    checkInternetOnInit();
    connectivitySubscription =
        connectivityService.connectivityStream.listen(onResult);

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(navigationDelegate)
      ..loadRequest(Uri.parse(loginUrl));
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> checkInternetOnInit() async {
    final result = await connectivityService.connectivityResult;
    final bool value = connectivityService.hasInternet(result);
    setState(() => hasInternet = value);
  }

  void onResult(ConnectivityResult result) {
    final value = connectivityService.hasInternet(result);
    setState(() => hasInternet = value);
    checkRequest(currentIndex);
  }

  String get loginUrl => UriConstants.login;
  String get homeUrl => UriConstants.home;
  String get basketUrl => '${UriConstants.basket}/$userId';
  String get accountUrl => '${UriConstants.account}/$userId';

  NavigationDelegate get navigationDelegate => NavigationDelegate(
        onNavigationRequest: onNavigationRequest,
        onPageStarted: onPageStarted,
        onPageFinished: onPageFinished,
      );

  FutureOr<NavigationDecision> onNavigationRequest(request) {
    if (request.url == loginUrl) {
      setState(() => isLoading = true);
      StorageService.clearStorage();
      Navigator.pushReplacementNamed(
        context,
        RouteConstants.login,
      );
    } else if (request.url == homeUrl) {
      updateIndex(0);
    } else if (request.url == basketUrl) {
      updateIndex(1);
    } else if (request.url == accountUrl) {
      updateIndex(2);
    }
    return NavigationDecision.navigate;
  }

  void onPageStarted(String url) {
    checkIfFirstLogin(url);
  }

  void onPageFinished(String url) {
    if (url == loginUrl) {
      if (StorageService.isLoggedIn) logInFromWebView();
    }
    checkIfStillLoading(url);
  }

  void onNavBarButtonTap(int value) {
    updateIndex(value);
    checkRequest(currentIndex);
    if (isLoading) setState(() => isLoading = false);
  }

  void updateIndex(int value) => setState(() => currentIndex = value);

  void checkRequest(int value) {
    switch (value) {
      case 0:
        loadRequest(homeUrl);
        break;
      case 1:
        loadRequest(basketUrl);
        break;
      case 2:
        loadRequest(accountUrl);
        break;
    }
  }

  Future<void> loadRequest(String uri) async {
    await webViewController.loadRequest(Uri.parse(uri));
  }

  void logInFromWebView() {
    final String javaScriptCode = '''
      var phoneField = document.querySelector("input[name=tel]");
      var passwordField = document.querySelector("input[name=parola]");
      var loginButton = document.querySelector("button");
      phoneField.value = '${StorageService.phoneNumber}';
      passwordField.value = '${StorageService.password}';
      loginButton.click();
    ''';
    webViewController.runJavaScript(javaScriptCode);
  }

  void checkIfFirstLogin(String url) {
    if (userId == -1 && url.contains(homeUrl)) {
      userId = extractIdFromUrl(url);
      StorageService.userId = userId;
    }
  }

  void checkIfStillLoading(String url) {
    if (isLoading && url.contains(homeUrl)) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget get body {
    return SafeArea(
      child: hasInternet ? onlineWidget : offlineWidget,
    );
  }

  Widget get onlineWidget {
    return isLoading
        ? const LoadingWidget()
        : WebViewWidget(controller: webViewController);
  }

  Widget get offlineWidget => const NoInternetWidget();

  Widget get checkingWidget {
    return const Center(
      child: CircularProgressIndicator(color: Colors.black),
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: navBarDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavBarItem(
            onTap: () => onNavBarButtonTap(0),
            icon: FontAwesomeIcons.house,
            text: 'Ana Sayfa',
            isSelected: currentIndex == 0,
          ),
          BottomNavBarItem(
            onTap: () => onNavBarButtonTap(1),
            icon: FontAwesomeIcons.basketShopping,
            text: 'Sepet',
            isSelected: currentIndex == 1,
          ),
          BottomNavBarItem(
            onTap: () => onNavBarButtonTap(2),
            icon: FontAwesomeIcons.solidUser,
            text: 'Hesap',
            isSelected: currentIndex == 2,
          ),
        ],
      ),
    );
  }

  BoxDecoration get navBarDecoration {
    return const BoxDecoration(
      color: ColorConstants.primaryColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 10,
          offset: Offset(0, -2),
        ),
      ],
    );
  }
}
