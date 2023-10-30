import 'package:flutter/material.dart';
import 'package:netvetta/constants/uri_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(UriConstants.signUp));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebViewWidget(controller: webViewController),
    );
  }
}
