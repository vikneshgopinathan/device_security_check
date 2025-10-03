import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_security_check/src/platform/device_security_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('DeviceSecurityPlatform', () {
    late DeviceSecurityPlatform platform;

    setUp(() {
      platform = DeviceSecurityPlatform();
    });

    group('getDeviceSecurityStatus', () {
      test('returns security status when method call succeeds', () async {
        // Mock successful method call
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          if (call.method == 'getDeviceSecurityStatus') {
            return {
              'compromised': false,
              'type': 'safe',
              'message': 'Device is secure.'
            };
          }
          throw PlatformException(code: 'UNIMPLEMENTED');
        });

        final result = await platform.getDeviceSecurityStatus();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['compromised'], false);
        expect(result['type'], 'safe');
        expect(result['message'], 'Device is secure.');
      });

      test('returns safe status when method call fails', () async {
        // Mock failed method call
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          throw PlatformException(code: 'ERROR');
        });

        final result = await platform.getDeviceSecurityStatus();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['compromised'], false);
        expect(result['type'], 'safe');
        expect(result['message'], 'Unable to determine device security status');
      });

      test('handles compromised device status', () async {
        // Mock compromised device
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          if (call.method == 'getDeviceSecurityStatus') {
            return {
              'compromised': true,
              'type': 'jailbreak',
              'message': 'Device integrity is compromised due to jailbreaking.'
            };
          }
          throw PlatformException(code: 'UNIMPLEMENTED');
        });

        final result = await platform.getDeviceSecurityStatus();

        expect(result['compromised'], true);
        expect(result['type'], 'jailbreak');
        expect(result['message'],
            'Device integrity is compromised due to jailbreaking.');
      });

      test('handles developer mode status', () async {
        // Mock developer mode enabled
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          if (call.method == 'getDeviceSecurityStatus') {
            return {
              'compromised': true,
              'type': 'developer_mode',
              'message':
                  'Developer mode is enabled. Please disable it and restart the app.'
            };
          }
          throw PlatformException(code: 'UNIMPLEMENTED');
        });

        final result = await platform.getDeviceSecurityStatus();

        expect(result['compromised'], true);
        expect(result['type'], 'developer_mode');
        expect(result['message'],
            'Developer mode is enabled. Please disable it and restart the app.');
      });
    });

    group('isDeviceCompromised', () {
      test('returns false for secure device', () async {
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          if (call.method == 'getDeviceSecurityStatus') {
            return {
              'compromised': false,
              'type': 'safe',
              'message': 'Device is secure.'
            };
          }
          throw PlatformException(code: 'UNIMPLEMENTED');
        });

        final result = await platform.isDeviceCompromised();

        expect(result, false);
      });

      test('returns true for compromised device', () async {
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          if (call.method == 'getDeviceSecurityStatus') {
            return {
              'compromised': true,
              'type': 'jailbreak',
              'message': 'Device integrity is compromised due to jailbreaking.'
            };
          }
          throw PlatformException(code: 'UNIMPLEMENTED');
        });

        final result = await platform.isDeviceCompromised();

        expect(result, true);
      });

      test('returns false when method call fails', () async {
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          throw PlatformException(code: 'ERROR');
        });

        final result = await platform.isDeviceCompromised();

        expect(result, false);
      });

      test('handles null compromised value', () async {
        const MethodChannel('device_security_channel')
            .setMockMethodCallHandler((call) async {
          if (call.method == 'getDeviceSecurityStatus') {
            return {
              'compromised': null,
              'type': 'unknown',
              'message': 'Unknown status'
            };
          }
          throw PlatformException(code: 'UNIMPLEMENTED');
        });

        final result = await platform.isDeviceCompromised();

        expect(result, false);
      });
    });
  });
}
