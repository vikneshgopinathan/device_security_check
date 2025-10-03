import 'package:device_security_check/src/domain/device_security_service.dart';
import 'package:device_security_check/src/platform/device_security_platform.dart';

// Export the main API
export 'package:device_security_check/src/domain/device_security_service.dart';
export 'package:device_security_check/src/platform/device_security_platform.dart';
export 'package:device_security_check/src/presentation/device_security_check_widget.dart';

class DeviceSecurityCheck {
  static final DeviceSecurityService _service =
      DeviceSecurityService(DeviceSecurityPlatform());

  static Future<bool> isDeviceSecure() async {
    return _service.isDeviceSecure();
  }

  static Future<Map<String, dynamic>> getDeviceSecurityStatus() async {
    return _service.getDeviceSecurityStatus();
  }
}
