# Testing Guide for Device Security Check Plugin

This document provides comprehensive information about testing the Device Security Check plugin.

## Test Structure

The plugin includes two types of tests:

### 1. Unit Tests
- **Location**: `test/` directory
- **Purpose**: Test individual components in isolation
- **Coverage**: Platform interface, domain service, and main plugin class

### 2. Widget Tests
- **Location**: `test/src/presentation/`
- **Purpose**: Test UI components and user interactions
- **Coverage**: DeviceSecurityCheckWidget functionality

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Types

#### Unit Tests Only
```bash
flutter test test/
```

#### Widget Tests Only
```bash
flutter test test/src/presentation/
```


### Using the Test Runner
```bash
dart test_runner.dart
```

## Test Files Overview

### Unit Tests

#### `test/src/platform/device_security_platform_test.dart`
Tests the platform interface layer:
- Method channel communication
- Error handling
- Security status parsing
- Compromised device detection

#### `test/src/domain/device_security_service_test.dart`
Tests the domain service layer:
- Business logic validation
- Service integration
- Status mapping

#### `test/device_security_check_test.dart`
Tests the main plugin class:
- API consistency
- Static method functionality
- Integration between layers

### Widget Tests

#### `test/src/presentation/device_security_check_widget_test.dart`
Tests the UI widget:
- Loading states
- Secure device display
- Compromised device display
- Error handling
- Refresh functionality
- User interactions


## Test Scenarios Covered

### Security Status Scenarios
- ✅ Secure device (compromised: false, type: 'safe')
- ✅ Jailbroken device (compromised: true, type: 'jailbreak')
- ✅ Developer mode enabled (compromised: true, type: 'developer_mode')
- ✅ Error states (compromised: false, type: 'error')

### UI Scenarios
- ✅ Loading state display
- ✅ Secure device UI (green icon, secure message)
- ✅ Compromised device UI (warning icon, compromised message)
- ✅ Error state UI (warning icon, error message)
- ✅ Refresh button functionality
- ✅ Status transitions

### Platform Channel Scenarios
- ✅ Successful method calls
- ✅ Error handling
- ✅ Concurrent API calls
- ✅ Mock platform responses
- ✅ Channel cleanup

## Mocking Strategy

### Platform Interface Mocking
- Uses `MethodChannel.setMockMethodCallHandler()` for platform channel mocking
- Simulates different security states
- Tests error conditions

### Service Layer Mocking
- Custom mock classes for `DeviceSecurityPlatform`
- Controlled test scenarios
- Isolated business logic testing

### Widget Mocking
- Mock `DeviceSecurityCheck` class for widget tests
- Simulates different API responses
- Tests UI state management

## Test Data

### Secure Device Response
```dart
{
  'compromised': false,
  'type': 'safe',
  'message': 'Device is secure.'
}
```

### Compromised Device Response
```dart
{
  'compromised': true,
  'type': 'jailbreak',
  'message': 'Device integrity is compromised due to jailbreaking.'
}
```

### Developer Mode Response
```dart
{
  'compromised': true,
  'type': 'developer_mode',
  'message': 'Developer mode is enabled. Please disable it and restart the app.'
}
```

### Error Response
```dart
{
  'compromised': false,
  'type': 'safe',
  'message': 'Unable to determine device security status'
}
```

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test
      - run: flutter test integration_test/
```

### Test Coverage
To generate test coverage reports:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Troubleshooting

### Common Issues

1. **Method Channel Errors**: Ensure proper cleanup of mock handlers
2. **Widget Test Timeouts**: Use `pumpAndSettle()` for async operations
3. **Integration Test Failures**: Check platform channel setup
4. **Mock Data Issues**: Verify mock response structure matches expected format

### Debug Tips

1. Use `flutter test --verbose` for detailed output
2. Add `print()` statements in tests for debugging
3. Use `tester.pump()` and `tester.pumpAndSettle()` appropriately
4. Verify mock data structure matches real API responses

## Best Practices

1. **Isolation**: Each test should be independent
2. **Mocking**: Use appropriate mocks for each layer
3. **Coverage**: Aim for high test coverage
4. **Maintenance**: Keep tests updated with code changes
5. **Documentation**: Document complex test scenarios
