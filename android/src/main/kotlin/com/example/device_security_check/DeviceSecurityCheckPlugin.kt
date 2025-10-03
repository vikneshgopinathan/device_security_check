package com.example.device_security_check

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class DeviceSecurityCheckPlugin: FlutterPlugin {
    private lateinit var deviceSecurityPlugin: DeviceSecurityPlugin

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        deviceSecurityPlugin = DeviceSecurityPlugin()
        deviceSecurityPlugin.onAttachedToEngine(flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        deviceSecurityPlugin.onDetachedFromEngine(binding)
    }
}