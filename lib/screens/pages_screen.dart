import 'dart:async';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../constants/uri_constants.dart';
import '../services/local_storage_service.dart';
import 'login_screen.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({Key? key}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  int currentIndex = 0;
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: onNavigationRequest,
          onPageFinished: onPageFinished,
        ),
      )
      ..loadRequest(Uri.parse(UriConstants.login));
  }

  FutureOr<NavigationDecision> onNavigationRequest(NavigationRequest request) {
    switch (request.url) {
      case UriConstants.login:
        navigateToLoginScreen();
        break;
      case UriConstants.home:
        loadPage(0);
        break;
      case UriConstants.basket:
        loadPage(1);
        break;
      case UriConstants.account:
        loadPage(2);
        break;
    }
    return NavigationDecision.navigate;
  }

  void navigateToLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => route.isFirst,
    );
    LocalStorageService.isLoggedIn = false;
  }

  void loadPage(int value) {
    currentIndex = value;
    switch (currentIndex) {
      case 0:
        loadRequest(UriConstants.home);
        break;
      case 1:
        loadRequest(UriConstants.basket);
        break;
      case 2:
        loadRequest(UriConstants.account);
        break;
    }
    setState(() {});
  }

  void loadRequest(String uri) {
    webViewController.loadRequest(Uri.parse(uri));
  }

  void onPageFinished(String url) {
    webViewController.runJavaScript('''
      var phoneField = document.querySelector("input[name=tel]");
      var passwordField = document.querySelector("input[name=parola]");
      var loginButton = document.querySelector("button");
      phoneField.value = '${LocalStorageService.phoneNumber}';
      passwordField.value = '${LocalStorageService.password}';
      loginButton.click();
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  /*AppBar get appBar {
    return AppBar(
      backgroundColor: const Color(0xff2A3F54),
      //title: Text(appBarTitle),
      automaticallyImplyLeading: false,
      titleSpacing: 20,
    );
  }*/

  Widget get body {
    return SafeArea(
      child: WebViewWidget(controller: webViewController),
    );
  }

  Widget get bottomNavigationBar {
    return BottomNavigationBar(
      backgroundColor: const Color(0xff2A3F54),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white38,
      onTap: loadPage,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Sepet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: 'Hesap',
        ),
      ],
    );
  }
}
