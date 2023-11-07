import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
    this.onWebViewCreated,
    this.onWebViewPageFinished,
    required this.backAction
  });

  final String url;
  final String title;
  final Function(String)? onWebViewCreated;
  final Function(String)? onWebViewPageFinished;
  final Function backAction;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            widget.onWebViewCreated?.call(url);
          },
          onPageFinished: (String url) {
            widget.onWebViewPageFinished?.call(url);
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error : $error');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            widget.backAction();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.search),
        ),
      ),
      body: WebViewWidget(
        controller: _controller,
      )
    );
  }
}
