import Flutter
import UIKit

public class DeviceSecurityPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "device_security_channel", binaryMessenger: registrar.messenger())
        let instance = DeviceSecurityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getDeviceSecurityStatus" {
            let status = getSecurityStatus()
            result(status)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func getSecurityStatus() -> [String: Any] {
        if isJailbroken() {
            return [
                "compromised": true,
                "type": "jailbreak",
                "message": "Device integrity is compromised due to jailbreaking."
            ]
        }

        if isDeveloperModeEnabled() {
            return [
                "compromised": true,
                "type": "developer_mode",
                "message": "Developer mode is enabled. Please disable it and restart the app."
            ]
        }

        return [
            "compromised": false,
            "type": "safe",
            "message": "Device is secure."
        ]
    }

    private func isJailbroken() -> Bool {
        if TARGET_IPHONE_SIMULATOR != 0 {
            // Simulator is not jailbroken
            return false
        }

        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia"
        ]

        for path in jailbreakFilePaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        // Test if app can write outside sandbox (common jailbreak sign)
        let testPath = "/private/jailbreak_test.txt"
        do {
            try "Jailbreak Test".write(toFile: testPath, atomically: true, encoding: String.Encoding.utf8)
            // Cleanup the test file
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            // Cannot write, not jailbroken by this check
        }

        return false
    }

    private func isDeveloperModeEnabled() -> Bool {
        // iOS does not provide a direct way to detect developer mode.
        // Approximate detection: check for debugger presence or environment variables.

        // Check for debugger:
        var info = kinfo_proc()
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]

        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")

        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}
