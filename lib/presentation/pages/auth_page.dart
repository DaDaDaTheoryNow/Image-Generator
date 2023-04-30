import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatelessWidget {
  final String url;

  const AuthPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://replicate.com/account'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go to the token'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
