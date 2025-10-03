import 'package:flutter/material.dart';
import 'package:device_security_check/device_security_check.dart';

class DeviceSecurityCheckWidget extends StatefulWidget {
  /// Custom widget to display when device is compromised (if not provided, shows full page error)
  final Widget? errorWidget;

  /// Widget to display when device is secure
  final Widget child;

  /// Custom widget to display while loading
  final Widget? loadingWidget;

  /// Callback function when device security status changes
  final Function(Map<String, dynamic>)? onStatusChanged;

  const DeviceSecurityCheckWidget({
    Key? key,
    required this.child,
    this.errorWidget,
    this.loadingWidget,
    this.onStatusChanged,
  }) : super(key: key);

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

      // Call the callback if provided
      if (widget.onStatusChanged != null) {
        widget.onStatusChanged!(status);
      }
    } catch (e) {
      setState(() {
        _isSecure = false;
        _statusMessage = 'Error checking device security: $e';
        _statusType = 'error';
        _isLoading = false;
      });

      // Call the callback with error status
      if (widget.onStatusChanged != null) {
        widget.onStatusChanged!({
          'compromised': true,
          'type': 'error',
          'message': 'Error checking device security: $e'
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingWidget();
    } else if (!_isSecure) {
      // Device is compromised
      if (widget.errorWidget != null) {
        return widget.errorWidget!;
      } else {
        // Show full page error by default
        return _buildFullPageError();
      }
    } else {
      // Device is secure - show the child widget
      return widget.child;
    }
  }

  Widget _buildLoadingWidget() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Checking device security...'),
          ],
        ),
      ),
    );
  }

  Widget _buildFullPageError() {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Security Alert',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Threat Type: ${_statusType.toUpperCase()}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              const Text(
                'This app cannot run on compromised devices for security reasons.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _checkDeviceSecurity,
                child: const Text('Retry Security Check'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
