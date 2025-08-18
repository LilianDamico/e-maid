import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/api_config.dart';
import '../../config/return_urls.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;              // <— nome que seu código usa
  final Map<String, dynamic> bookingData;

  const PaymentWebViewScreen({
    super.key,
    required this.checkoutUrl,
    required this.bookingData,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebViewPlatform.instance;

    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.startsWith(ReturnUrls.success)) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }
            if (url.startsWith(ReturnUrls.failure)) {
              Navigator.pop(context, 'failure');
              return NavigationDecision.prevent;
            }
            if (url.startsWith(ReturnUrls.pending)) {
              Navigator.pop(context, 'pending');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
