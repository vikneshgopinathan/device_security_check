package com.example.device_security_check

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class DeviceSecurityCheckPluginRegistrant {
    companion object {
        fun registerWith(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_security_channel")
            val instance = DeviceSecurityPlugin()
            channel.setMethodCallHandler(instance)
        }
    }
}
