package com.example.device_security_check

import android.content.Context
import android.provider.Settings
import android.os.Build
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class DeviceSecurityPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "device_security_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getDeviceSecurityStatus") {
            val securityStatus = getSecurityStatus()
            result.success(securityStatus)
        } else {
            result.notImplemented()
        }
    }

    private fun getSecurityStatus(): Map<String, Any> {
        return when {
            isRooted() -> mapOf(
                "compromised" to true,
                "type" to "jailbreak",
                "message" to "Device integrity is compromised due to rooting or jailbreaking."
            )
            isDeveloperModeEnabled() -> mapOf(
                "compromised" to true,
                "type" to "developer_mode",
                "message" to "Developer mode is enabled. Please disable it and restart the app."
            )
            else -> mapOf(
                "compromised" to false,
                "type" to "safe",
                "message" to "Device is secure."
            )
        }
    }

    // Root detection logic
    private fun isRooted(): Boolean {
        return checkRootFiles() || checkRootManagementApps() || checkBuildTags()
    }

    private fun checkRootFiles(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su"
        )
        return paths.any { path -> File(path).exists() }
    }

    private fun checkRootManagementApps(): Boolean {
        val packages = listOf(
            "com.noshufou.android.su",
            "com.koushikdutta.superuser",
            "eu.chainfire.supersu",
            "com.topjohnwu.magisk"
        )
        packages.forEach { packageName ->
            try {
                context.packageManager.getPackageInfo(packageName, 0)
                return true
            } catch (e: PackageManager.NameNotFoundException) {
                // Package not found, continue
            }
        }
        return false
    }

    private fun checkBuildTags(): Boolean {
        val buildTags = Build.TAGS
        return buildTags != null && buildTags.contains("test-keys")
    }

    // Developer mode detection
    private fun isDeveloperModeEnabled(): Boolean {
        return try {
            Settings.Secure.getInt(context.contentResolver, Settings.Secure.DEVELOPMENT_SETTINGS_ENABLED, 0) == 1
        } catch (e: Settings.SettingNotFoundException) {
            false
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
