// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netvetta/utils/globals.dart';
import 'package:netvetta/widgets/internet_connectivity_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/account_sub_buttons_widget.dart';
import '../constants/api_constants.dart';
import '../constants/color_constants.dart';
import '../constants/route_constants.dart';
import '../constants/uri_constants.dart';
import '../services/storage_service.dart';
import '../utils/function_utils.dart';
import '../widgets/bottom_navbar_item.dart';
import '../widgets/loading_widget.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  bool hasInternet = false;

  late final WebViewController webViewController;
  int currentIndex = 0;
  bool isLoading = true;
  late int userId;

  bool showAccountSubButtons = false;

  @override
  void initState() {
    super.initState();
    internetNotifier.addListener(() {
      checkRequest(currentIndex);
    });

    userId = StorageService.userId;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(navigationDelegate)
      ..loadRequest(Uri.parse(loginUrl));
  }

  String get loginUrl => UriConstants.login;
  String get homeUrl => UriConstants.home;
  String get basketUrl => '${UriConstants.basket}/$userId';
  String get accountUrl => '${UriConstants.account}/$userId';

  NavigationDelegate get navigationDelegate {
    return NavigationDelegate(
      onNavigationRequest: onNavigationRequest,
      onPageStarted: onPageStarted,
      onPageFinished: onPageFinished,
    );
  }

  FutureOr<NavigationDecision> onNavigationRequest(request) async {
    if (request.url == homeUrl) {
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
    if (url.contains(homeUrl)) checkIfStillLoading(url);
  }

  void onNavigationBarTap(int value) {
    showAccountSubButtons = false;
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
      var userCodeField = document.querySelector('input[name=kk]');
      var phoneField = document.querySelector('input[name=tel]');
      var passwordField = document.querySelector('input[name=parola]');
      var loginButton = document.querySelector('button');
      userCodeField.value = '${StorageService.userCode}';
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

  Future<void> checkIfStillLoading(String url) async {
    if (isLoading) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => isLoading = false);
    }
  }

  Future<void> onLogOutPressed() async {
    if (internetNotifier.value) {
      await StorageService.clearStorage();
      await loadRequest(ApiConstants.logOutUrl);
      Navigator.pushReplacementNamed(context, RouteConstants.login);
    } else {
      onNavigationBarTap(2);
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
      child: InternetConnectivityWidget(online: onlineWidget),
    );
  }

  Widget get onlineWidget {
    return isLoading
        ? const LoadingWidget()
        : WebViewWidget(controller: webViewController);
  }

  Widget get bottomNavigationBar {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavBarItem(
            onTap: () => onNavigationBarTap(0),
            icon: FontAwesomeIcons.house,
            text: 'Ana Sayfa',
            isSelected: currentIndex == 0,
          ),
          BottomNavBarItem(
            onTap: () => onNavigationBarTap(1),
            icon: FontAwesomeIcons.basketShopping,
            text: 'Sepet',
            isSelected: currentIndex == 1,
          ),
          Visibility(
            visible: !showAccountSubButtons,
            replacement: accountSubButtons,
            child: BottomNavBarItem(
              onTap: () => setState(() => showAccountSubButtons = true),
              icon: FontAwesomeIcons.solidCircleUser,
              text: 'Hesap',
              isSelected: currentIndex == 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget get accountSubButtons {
    return AccountSubButtons(
      onPersonalPressed: () => onNavigationBarTap(2),
      onLogOutPressed: onLogOutPressed,
      isSelected: currentIndex == 2,
    );
  }
}
