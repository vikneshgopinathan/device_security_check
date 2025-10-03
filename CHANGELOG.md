# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2024-12-19

### Added
- Enhanced .gitignore with comprehensive Flutter plugin exclusions
- Added platform-specific build artifact exclusions (Android, iOS, macOS, Windows, Linux, Web)
- Added IDE and OS-specific file exclusions
- Added test coverage file exclusions
- Added proper MIT License file

### Fixed
- Fixed pubspec.yaml description length for pub.dev compliance (under 180 characters)
- Fixed Dart code formatting issues with dart format
- Improved package quality score for pub.dev publishing

### Improved
- Better project structure for Flutter plugin development
- More comprehensive file exclusions for cleaner repository
- Enhanced development experience with proper .gitignore
- All pub.dev publishing requirements met

## [0.1.0] - 2024-12-19

### Added
- Enhanced `DeviceSecurityCheckWidget` with custom widgets support
- Added required `child` parameter for secure device content
- Added optional `errorWidget` for custom compromised device display
- Added optional `loadingWidget` for custom loading states
- Added `onStatusChanged` callback for status change notifications
- Implemented full-page error display when no custom error widget provided
- Added comprehensive documentation and usage examples
- Added example app demonstrating enhanced widget usage
- Added Android namespace configuration for Gradle 8.1.0 compatibility
- Added plugin registration for proper Flutter plugin auto-discovery

### Changed
- **BREAKING**: `DeviceSecurityCheckWidget` now requires `child` parameter
- **BREAKING**: Import path simplified - `DeviceSecurityCheckWidget` now available from main package
- Updated all examples and documentation to use simplified import path
- Enhanced widget tests to match new API and avoid timeout issues
- Updated Android build configuration for better compatibility

### Fixed
- Fixed Android build namespace issues
- Fixed widget test timeouts by removing `pumpAndSettle()` calls
- Fixed plugin registration issues for external app usage

### Migration Guide
- **Import Change**: 
  - Old: `import 'package:device_security_check/src/presentation/device_security_check_widget.dart';`
  - New: `import 'package:device_security_check/device_security_check.dart';`
- **Widget Usage**:
  - Old: `DeviceSecurityCheckWidget()`
  - New: `DeviceSecurityCheckWidget(child: YourWidget())`

## [0.0.1] - 2024-12-19

### Added
- Initial release of device_security_check plugin
- Android root detection capabilities
- iOS jailbreak detection capabilities
- Developer mode detection for both platforms
- Basic `DeviceSecurityCheck` API with `isDeviceSecure()` and `getDeviceSecurityStatus()`
- Unit and widget tests
- Basic documentation and examples