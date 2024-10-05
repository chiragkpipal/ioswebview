import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add this import
import 'package:webview_firebase_app/webview_page.dart'; // Correctly import WebViewPage

void main() {
  testWidgets('WebViewPage loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: WebViewPage())); // No 'const' here

    // Verify that the WebView is displayed.
    expect(find.byType(WebView), findsOneWidget); // Check if WebView is present
  });
}
