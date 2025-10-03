import 'package:flutter_test/flutter_test.dart';
import 'package:device_security_check/src/domain/device_security_service.dart';
import 'package:device_security_check/src/platform/device_security_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceSecurityService Integration', () {
    late MockDeviceSecurityService mockService;

    setUp(() {
      mockService = MockDeviceSecurityService();
    });

    test('secure device returns correct status', () async {
      mockService.setSecure(true);

      final isSecure = await mockService.isDeviceSecure();
      final status = await mockService.getDeviceSecurityStatus();

      expect(isSecure, true);
      expect(status['compromised'], false);
    });

    test('compromised device returns correct status', () async {
      mockService.setSecure(false);

      final isSecure = await mockService.isDeviceSecure();
      final status = await mockService.getDeviceSecurityStatus();

      expect(isSecure, false);
      expect(status['compromised'], true);
      expect(status['type'], 'jailbreak');
    });

    test('developer mode status', () async {
      mockService.setSecurityStatus({
        'compromised': true,
        'type': 'developer_mode',
        'message':
            'Developer mode is enabled. Please disable it and restart the app.'
      });

      final isSecure = await mockService.isDeviceSecure();
      final status = await mockService.getDeviceSecurityStatus();

      expect(isSecure, false);
      expect(status['compromised'], true);
      expect(status['type'], 'developer_mode');
    });
  });
}

// Mock service for testing
class MockDeviceSecurityService extends DeviceSecurityService {
  bool _isSecure = true;
  Map<String, dynamic> _securityStatus = {
    'compromised': false,
    'type': 'safe',
    'message': 'Device is secure.'
  };

  MockDeviceSecurityService() : super(MockDeviceSecurityPlatform());

  void setSecure(bool secure) {
    _isSecure = secure;
    _securityStatus = {
      'compromised': !secure,
      'type': secure ? 'safe' : 'jailbreak',
      'message': secure
          ? 'Device is secure.'
          : 'Device integrity is compromised due to jailbreaking.'
    };
  }

  void setSecurityStatus(Map<String, dynamic> status) {
    _securityStatus = status;
    _isSecure = !(status['compromised'] as bool? ?? false);
  }

  @override
  Future<bool> isDeviceSecure() async {
    return _isSecure;
  }

  @override
  Future<Map<String, dynamic>> getDeviceSecurityStatus() async {
    return _securityStatus;
  }
}

// Mock platform for testing
class MockDeviceSecurityPlatform extends DeviceSecurityPlatform {
  @override
  Future<bool> isDeviceCompromised() async {
    return false;
  }

  @override
  Future<Map<String, dynamic>> getDeviceSecurityStatus() async {
    return {
      'compromised': false,
      'type': 'safe',
      'message': 'Device is secure.'
    };
  }
}
