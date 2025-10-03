#!/usr/bin/env dart

import 'dart:io';

void main(List<String> arguments) async {
  print('🧪 Running Device Security Check Tests');
  print('=====================================\n');

  // Run all tests
  print('📋 Running All Tests...');
  final testResult = await Process.run(
    'flutter',
    ['test', 'test/'],
    workingDirectory: Directory.current.path,
  );

  if (testResult.exitCode == 0) {
    print('✅ All tests passed!\n');
    print('🎉 Test suite completed successfully!');
  } else {
    print('❌ Tests failed:');
    print(testResult.stderr);
    exit(1);
  }
}
