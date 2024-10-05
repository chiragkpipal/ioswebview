import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    setupFirebase();
  }

  void setupFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the FCM token
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    // Load the WebView after Firebase setup
    _controller.loadUrl("https://shop2.wanslu.com");
  }

  Future<void> _captureUserIdCookie() async {
    String cookieString = await _controller.runJavascriptReturningResult("document.cookie");

  // Ensure the string is properly trimmed (it may have extra double quotes)
  cookieString = cookieString.replaceAll("\"", ""); // Remove double quotes

  // Split the cookie string and look for user_id cookie
  List<String> cookies = cookieString.split('; ');
  String? userIdCookie = cookies.firstWhere(
    (cookie) => cookie.startsWith('user_id='),
    orElse: () => '',
  );

  if (userIdCookie.isNotEmpty) {
    // Extract the value from the cookie string
    String userId = userIdCookie.split('=')[1];
    await _sendDataToServer(userId);
  } else {
    print("No user_id cookie found");
  }
  }

  Future<void> _sendDataToServer(String userId) async {
    final response = await http.post(
      Uri.parse("https://shop2.wanslu.com/save-fcm-ios"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fcm_token': await FirebaseMessaging.instance.getToken(),
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      print("Data sent successfully");
    } else {
      print("Failed to send data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView with FCM"),
      ),
      body: WebView(
        initialUrl: "https://shop2.wanslu.com",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;

          // Set a custom cookie
          controller.runJavascript("document.cookie = 'app=1';");
        },
        onPageFinished: (String url) {
          _captureUserIdCookie();
        },
      ),
    );
  }
}
