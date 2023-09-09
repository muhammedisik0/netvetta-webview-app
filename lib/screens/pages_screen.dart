import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/uri_constants.dart';
import '../services/storage_service.dart';
import '../utils/globals.dart';
import '../utils/url_utils.dart';
import '../widgets/bottom_navbar_item.dart';
import '../widgets/loading_widget.dart';
import 'login_screen.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  late final WebViewController webViewController;
  int currentIndex = 0;
  bool isLoading = true;
  late int userId;

  String get loginUrl => UriConstants.login;
  String get homeUrl => UriConstants.home;
  String get basketUrl => '${UriConstants.basket}/$userId';
  String get accountUrl => '${UriConstants.account}/$userId';

  @override
  void initState() {
    super.initState();
    userId = StorageService.userId;

    hasInternet.addListener(() async {
      if (hasInternet.value && isLoading) {
        await loadRequest(homeUrl);
        setState(() => isLoading = false);
      }
    });

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: onNavigationRequest,
          onPageStarted: onPageStarted,
          onPageFinished: onPageFinished,
        ),
      )
      ..loadRequest(Uri.parse(loginUrl));
  }

  FutureOr<NavigationDecision> onNavigationRequest(request) {
    if (request.url == loginUrl) {
      setState(() => isLoading = true);
      navigateToLoginScreen();
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
    if (url == loginUrl && StorageService.isLoggedIn) {
      logInFromWebView();
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
    webViewController.runJavaScript('''
      var phoneField = document.querySelector("input[name=tel]");
      var passwordField = document.querySelector("input[name=parola]");
      var loginButton = document.querySelector("button");
      phoneField.value = '${StorageService.phoneNumber}';
      passwordField.value = '${StorageService.password}';
      loginButton.click();
    ''');
  }

  void checkIfFirstLogin(String url) {
    if (userId == -1) {
      if (url.contains(homeUrl)) {
        userId = extractIdFromUrl(url);
        StorageService.userId = userId;
      }
    }
  }

  void checkIfStillLoading(String url) {
    if (isLoading) {
      if (url.contains(homeUrl)) {
        setState(() => isLoading = false);
      }
    }
  }

  void navigateToLoginScreen() {
    StorageService.clearStorage();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => route.isFirst,
    );
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
      child: isLoading
          ? const LoadingWidget()
          : WebViewWidget(controller: webViewController),
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xff2A3F54),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavBarItem(
            onTap: () => onNavBarButtonTap(0),
            icon: Icons.home,
            text: 'Ana Sayfa',
            isSelected: currentIndex == 0,
          ),
          BottomNavBarItem(
            onTap: () => onNavBarButtonTap(1),
            icon: Icons.shopping_basket,
            text: 'Sepet',
            isSelected: currentIndex == 1,
          ),
          BottomNavBarItem(
            onTap: () => onNavBarButtonTap(2),
            icon: Icons.account_box,
            text: 'Hesap',
            isSelected: currentIndex == 2,
          ),
        ],
      ),
    );
  }
}
