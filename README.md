# Device Security Check

A Flutter plugin that provides device security checking capabilities for both iOS and Android devices. This plugin can detect if a device is rooted/jailbroken, has developer mode enabled, or is otherwise compromised.

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

### Basic Usage

```dart
import 'package:device_security_check/device_security_check.dart';

// Check if device is secure
bool isSecure = await DeviceSecurityCheck.isDeviceSecure();

// Get detailed security status
Map<String, dynamic> status = await DeviceSecurityCheck.getDeviceSecurityStatus();
print('Compromised: ${status['compromised']}');
print('Type: ${status['type']}');
print('Message: ${status['message']}');
```

### Using the Widget

```dart
import 'package:device_security_check/src/presentation/device_security_check_widget.dart';

// Add to your widget tree
DeviceSecurityCheckWidget()
```

### Security Status Response

The `getDeviceSecurityStatus()` method returns a map with the following structure:

```dart
{
  'compromised': bool,    // true if device is compromised
  'type': String,         // 'safe', 'jailbreak', 'developer_mode', or 'error'
  'message': String       // Human-readable description
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

## Publishing to pub.dev

This package is ready to be published to [pub.dev](https://pub.dev). Before publishing:

1. **Update the repository URLs** in `pubspec.yaml`:
   - Replace `your-username` with your actual GitHub username
   - Update the repository URL to point to your actual repository

2. **Run tests** to ensure everything works:
   ```bash
   flutter test
   ```

3. **Check for issues**:
   ```bash
   flutter analyze
   ```

4. **Publish to pub.dev**:
   ```bash
   flutter pub publish
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

For more information about Flutter plugins, see the [Flutter documentation](https://flutter.dev/docs/development/packages-and-plugins/developing-packages).
