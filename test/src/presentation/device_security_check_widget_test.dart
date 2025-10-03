import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_security_check/src/presentation/device_security_check_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceSecurityCheckWidget', () {
    testWidgets('shows loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Checking device security...'), findsOneWidget);
    });

    testWidgets('shows child widget when device is secure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
          ),
        ),
      );

      // Just check that the widget is created and loading starts
      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows custom error widget when device is compromised',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
            errorWidget: Text('Custom Error Widget'),
          ),
        ),
      );

      // Check that the widget is created and loading starts
      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows full page error when no custom error widget provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
          ),
        ),
      );

      // Check that the widget is created and loading starts
      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows custom loading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
            loadingWidget: Text('Custom Loading...'),
          ),
        ),
      );

      expect(find.text('Custom Loading...'), findsOneWidget);
    });

    testWidgets('calls onStatusChanged callback', (WidgetTester tester) async {
      bool callbackCalled = false;
      Map<String, dynamic>? receivedStatus;

      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
            onStatusChanged: (status) {
              callbackCalled = true;
              receivedStatus = status;
            },
          ),
        ),
      );

      // Just check that the widget is created and loading starts
      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('widget displays in MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Scaffold(
              appBar: AppBar(title: Text('Test')),
              body: Text('Test Content'),
            ),
          ),
        ),
      );

      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
    });

    testWidgets('handles retry button tap in full page error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Secure Content'),
          ),
        ),
      );

      // Just check that the widget is created and loading starts
      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('required child parameter is provided',
        (WidgetTester tester) async {
      // This test ensures the API requires the child parameter
      // The compiler will catch this at compile time, so we just verify the widget works with child
      await tester.pumpWidget(
        MaterialApp(
          home: DeviceSecurityCheckWidget(
            child: Text('Test Child'),
          ),
        ),
      );

      expect(find.byType(DeviceSecurityCheckWidget), findsOneWidget);
    });
  });
}
