import '../platform/device_security_platform.dart';

class DeviceSecurityService {
  final DeviceSecurityPlatform _platform;

  DeviceSecurityService(this._platform);

  Future<bool> isDeviceSecure() async {
    // Additional business rules can go here
    final compromised = await _platform.isDeviceCompromised();
    return !compromised;
  }

  Future<Map<String, dynamic>> getDeviceSecurityStatus() async {
    return await _platform.getDeviceSecurityStatus();
  }
}
