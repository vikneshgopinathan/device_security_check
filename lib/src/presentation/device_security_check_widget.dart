import 'package:flutter/material.dart';
import 'package:device_security_check/device_security_check.dart';

class DeviceSecurityCheckWidget extends StatefulWidget {
  const DeviceSecurityCheckWidget({Key? key}) : super(key: key);

  @override
  State<DeviceSecurityCheckWidget> createState() =>
      _DeviceSecurityCheckWidgetState();
}

class _DeviceSecurityCheckWidgetState extends State<DeviceSecurityCheckWidget> {
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
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Security Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isSecure ? Icons.security : Icons.warning,
                        color: _isSecure ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSecure
                            ? 'Device is Secure'
                            : 'Device is Compromised',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isSecure ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: $_statusType',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkDeviceSecurity,
                    child: const Text('Refresh Status'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
