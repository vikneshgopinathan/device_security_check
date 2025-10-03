Pod::Spec.new do |s|
  s.name             = 'device_security_check'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for device security checking on iOS and Android.'
  s.description      = <<-DESC
A Flutter plugin that provides device security checking capabilities for iOS and Android devices. This plugin can detect if a device is rooted/jailbroken, has developer mode enabled, or is otherwise compromised.
                       DESC
  s.homepage         = 'https://github.com/your-username/device_security_check'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Name' => 'your-email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
