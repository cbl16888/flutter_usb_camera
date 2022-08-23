import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_usb_camera/flutter_usb_camera.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_platform_interface.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterUsbCameraPlatform 
    with MockPlatformInterfaceMixin
    implements FlutterUsbCameraPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> takePicture(String deviceId) {
    // TODO: implement takePicture
    throw UnimplementedError();
  }

  @override
  void setMessageHandler() {
    // TODO: implement setMessageHandler
  }

  @override
  // TODO: implement events
  Stream<USBCameraEvent> get events => throw UnimplementedError();
}

void main() {
  final FlutterUsbCameraPlatform initialPlatform = FlutterUsbCameraPlatform.instance;

  test('$MethodChannelFlutterUsbCamera is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterUsbCamera>());
  });

  test('getPlatformVersion', () async {
    FlutterUsbCamera flutterUsbCameraPlugin = FlutterUsbCamera();
    MockFlutterUsbCameraPlatform fakePlatform = MockFlutterUsbCameraPlatform();
    FlutterUsbCameraPlatform.instance = fakePlatform;
  
    expect(await flutterUsbCameraPlugin.getPlatformVersion(), '42');
  });
}
