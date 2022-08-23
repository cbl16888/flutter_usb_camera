import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_method_channel.dart';

void main() {
  MethodChannelFlutterUsbCamera platform = MethodChannelFlutterUsbCamera();
  const MethodChannel channel = MethodChannel('flutter_usb_camera');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
