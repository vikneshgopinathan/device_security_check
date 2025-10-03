import 'package:flutter_test/flutter_test.dart';
import 'package:device_security_check/src/domain/device_security_service.dart';
import 'package:device_security_check/src/platform/device_security_platform.dart';

// Mock platform for testing
class MockDeviceSecurityPlatform extends DeviceSecurityPlatform {
  bool _isCompromised = false;
  Map<String, dynamic> _securityStatus = {
    'compromised': false,
    'type': 'safe',
    'message': 'Device is secure.'
  };

  void setCompromised(bool compromised) {
    _isCompromised = compromised;
    _securityStatus = {
      'compromised': compromised,
      'type': compromised ? 'jailbreak' : 'safe',
      'message': compromised
          ? 'Device integrity is compromised due to jailbreaking.'
          : 'Device is secure.'
    };
  }

  void setSecurityStatus(Map<String, dynamic> status) {
    _securityStatus = status;
    _isCompromised = status['compromised'] as bool? ?? false;
  }

  @override
  Future<bool> isDeviceCompromised() async {
    return _isCompromised;
  }

  @override
  Future<Map<String, dynamic>> getDeviceSecurityStatus() async {
    return _securityStatus;
  }
}

void main() {
  group('DeviceSecurityService', () {
    late DeviceSecurityService service;
    late MockDeviceSecurityPlatform mockPlatform;

    setUp(() {
      mockPlatform = MockDeviceSecurityPlatform();
      service = DeviceSecurityService(mockPlatform);
    });

    group('isDeviceSecure', () {
      test('returns true when device is not compromised', () async {
        mockPlatform.setCompromised(false);

        final result = await service.isDeviceSecure();

        expect(result, true);
      });

      test('returns false when device is compromised', () async {
        mockPlatform.setCompromised(true);

        final result = await service.isDeviceSecure();

        expect(result, false);
      });

      test('handles jailbreak compromise', () async {
        mockPlatform.setSecurityStatus({
          'compromised': true,
          'type': 'jailbreak',
          'message': 'Device integrity is compromised due to jailbreaking.'
        });

        final result = await service.isDeviceSecure();

        expect(result, false);
      });

      test('handles developer mode compromise', () async {
        mockPlatform.setSecurityStatus({
          'compromised': true,
          'type': 'developer_mode',
          'message':
              'Developer mode is enabled. Please disable it and restart the app.'
        });

        final result = await service.isDeviceSecure();

        expect(result, false);
      });
    });

    group('getDeviceSecurityStatus', () {
      test('returns security status from platform', () async {
        final expectedStatus = {
          'compromised': false,
          'type': 'safe',
          'message': 'Device is secure.'
        };
        mockPlatform.setSecurityStatus(expectedStatus);

        final result = await service.getDeviceSecurityStatus();

        expect(result, equals(expectedStatus));
      });

      test('returns compromised status', () async {
        final expectedStatus = {
          'compromised': true,
          'type': 'jailbreak',
          'message': 'Device integrity is compromised due to jailbreaking.'
        };
        mockPlatform.setSecurityStatus(expectedStatus);

        final result = await service.getDeviceSecurityStatus();

        expect(result, equals(expectedStatus));
      });

      test('returns developer mode status', () async {
        final expectedStatus = {
          'compromised': true,
          'type': 'developer_mode',
          'message':
              'Developer mode is enabled. Please disable it and restart the app.'
        };
        mockPlatform.setSecurityStatus(expectedStatus);

        final result = await service.getDeviceSecurityStatus();

        expect(result, equals(expectedStatus));
      });
    });
  });
}
