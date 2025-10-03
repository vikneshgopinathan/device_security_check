import 'package:flutter/material.dart';
import 'package:device_security_check/src/presentation/device_security_check_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Security Check Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceSecurityCheckWidget(
        // Required: Widget to show when device is secure
        child: MyHomePage(),

        // Optional: Custom error widget (if not provided, shows full page error)
        // errorWidget: CustomErrorWidget(),

        // Optional: Custom loading widget
        // loadingWidget: CustomLoadingWidget(),

        // Optional: Callback when security status changes
        onStatusChanged: (status) {
          print(
              'Security status changed: ${status['type']} - ${status['message']}');
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure App'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Device Security Verified!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your device is secure and ready to use.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Welcome to the secure app!')),
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Custom Security Alert',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'This is a custom error widget that you can design however you want.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle retry or contact support
                },
                child: Text('Contact Support'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Performing security check...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
