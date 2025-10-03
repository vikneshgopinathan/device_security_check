# Device Security Check

A Flutter plugin that provides comprehensive device security checking capabilities for both iOS and Android devices. This plugin can detect if a device is rooted/jailbroken, has developer mode enabled, or is otherwise compromised.

## Features

### Android
- **Root Detection**: Detects if the device is rooted by checking for:
  - Common root files and binaries
  - Root management applications (SuperSU, Magisk, etc.)
  - Build tags that indicate test builds
- **Developer Mode Detection**: Checks if developer options are enabled

### iOS
- **Jailbreak Detection**: Detects if the device is jailbroken by checking for:
  - Common jailbreak files and directories (Cydia, MobileSubstrate, etc.)
  - Sandbox escape attempts
  - Jailbreak-specific file paths
- **Developer Mode Detection**: Checks for debugger presence and development environment

### Cross-Platform
- **Security Status**: Provides detailed information about device security status
- **Easy Integration**: Simple API for Flutter applications
- **Unified Interface**: Same API for both iOS and Android

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  device_security_check: ^0.0.1
```

### Installation

```bash
flutter pub add device_security_check
```

Or add it manually to your `pubspec.yaml`:

```yaml
dependencies:
  device_security_check: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

This plugin offers two main usage patterns depending on your security requirements:

### 1. App-Level Security Blocking

Use this approach when you want to block the entire app from running on compromised devices. This is ideal for banking, payment, or other security-sensitive applications.

#### Implementation in main.dart:

```dart
import 'package:flutter/material.dart';
import 'package:device_security_check/device_security_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check device security before running the app
  bool isDeviceSecure = await DeviceSecurityCheck.isDeviceSecure();
  
  if (!isDeviceSecure) {
    // Get detailed security information
    Map<String, dynamic> securityStatus = await DeviceSecurityCheck.getDeviceSecurityStatus();
    
    runApp(SecurityBlockedApp(securityStatus: securityStatus));
  } else {
    runApp(MyApp());
  }
}

class SecurityBlockedApp extends StatelessWidget {
  final Map<String, dynamic> securityStatus;
  
  const SecurityBlockedApp({Key? key, required this.securityStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[50],
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 80, color: Colors.red),
                SizedBox(height: 20),
                Text(
                  'Security Alert',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 16),
                Text(
                  securityStatus['message'] ?? 'Device security compromised',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Type: ${securityStatus['type']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),
                Text(
                  'This app cannot run on compromised devices for security reasons.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Secure App',
      home: HomePage(),
    );
  }
}
```

### 2. Widget-Level Security Checking

Use this approach when you want to show security information on specific pages or allow users to continue with warnings. This is ideal for apps that want to inform users about security risks but don't block functionality.

#### Using the Pre-built Widget:

```dart
import 'package:flutter/material.dart';
import 'package:device_security_check/src/presentation/device_security_check_widget.dart';

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Security')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Device Security Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Pre-built widget that handles all security checking and UI
            DeviceSecurityCheckWidget(),
          ],
        ),
      ),
    );
  }
}
```

#### Custom Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:device_security_check/device_security_check.dart';

class CustomSecurityWidget extends StatefulWidget {
  @override
  _CustomSecurityWidgetState createState() => _CustomSecurityWidgetState();
}

class _CustomSecurityWidgetState extends State<CustomSecurityWidget> {
  bool _isLoading = true;
  bool _isSecure = false;
  String _statusMessage = '';
  String _statusType = '';

  @override
  void initState() {
    super.initState();
    _checkDeviceSecurity();
  }

  Future<void> _checkDeviceSecurity() async {
    try {
      final status = await DeviceSecurityCheck.getDeviceSecurityStatus();
      setState(() {
        _isSecure = !(status['compromised'] as bool? ?? false);
        _statusMessage = status['message'] as String? ?? 'Unknown status';
        _statusType = status['type'] as String? ?? 'unknown';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isSecure = false;
        _statusMessage = 'Error checking device security: $e';
        _statusType = 'error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isSecure ? Icons.security : Icons.warning,
                  color: _isSecure ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  _isSecure ? 'Device is Secure' : 'Security Warning',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isSecure ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Status: $_statusType'),
            SizedBox(height: 4),
            Text(_statusMessage),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkDeviceSecurity,
              child: Text('Refresh Status'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Security Status Response

The `getDeviceSecurityStatus()` method returns a map with the following structure:

```dart
{
  'compromised': bool,    // true if device is compromised
  'type': String,          // 'safe', 'jailbreak', 'developer_mode', or 'error'
  'message': String        // Human-readable description
}
```

### Status Types

- **`safe`**: Device is secure
- **`jailbreak`**: Device is rooted or jailbroken
- **`developer_mode`**: Developer options are enabled
- **`error`**: Unable to determine status

## Platform Setup

### Android
This plugin requires Android API level 16 or higher. No additional permissions are required.

### iOS
This plugin requires iOS 11.0 or higher. No additional permissions are required.

## Example

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Device Security Check')),
        body: Center(
          child: DeviceSecurityCheckWidget(),
        ),
      ),
    );
  }
}
```

## Additional information

This plugin is designed for both iOS and Android devices and provides comprehensive security checking capabilities. It's particularly useful for applications that need to ensure device integrity for security-sensitive operations.

### iOS Jailbreak Detection Methods
- Checks for common jailbreak files and directories
- Tests sandbox escape capabilities
- Detects debugger presence
- Validates file system access patterns

### Android Root Detection Methods
- Scans for root binaries and management apps
- Checks build tags for test builds
- Validates system file integrity
- Detects developer mode settings



## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

For more information about Flutter plugins, see the [Flutter documentation](https://flutter.dev/docs/development/packages-and-plugins/developing-packages).
