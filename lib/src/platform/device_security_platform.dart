import 'package:flutter/services.dart';

class DeviceSecurityPlatform {
  static const MethodChannel _channel =
      MethodChannel('device_security_channel');

  Future<Map<String, dynamic>> getDeviceSecurityStatus() async {
    try {
      final Map<dynamic, dynamic> result =
          await _channel.invokeMethod('getDeviceSecurityStatus');
      return Map<String, dynamic>.from(result);
    } on PlatformException {
      return {
        'compromised': false,
        'type': 'safe',
        'message': 'Unable to determine device security status'
      };
    }
  }

  Future<bool> isDeviceCompromised() async {
    try {
      final Map<String, dynamic> status = await getDeviceSecurityStatus();
      return status['compromised'] as bool? ?? false;
    } on PlatformException {
      return false; // Default safe if platform call fails
    }
  }
}
