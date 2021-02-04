import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void coocier() async {
    final cookieManager = WebviewCookieManager();

    final gotCookies =
        await cookieManager.getCookies('https://bars.mpei.ru/bars_web/');
    for (var item in gotCookies) {
      print(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    coocier();
    return WebView(
      initialUrl: 'https://bars.mpei.ru/bars_web/',
    );
  }
}
