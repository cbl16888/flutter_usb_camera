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
  Future<String?> takePicture(int deviceId) {
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

  @override
  Future<bool?> startPreview(int deviceId) {
    // TODO: implement startPreview
    throw UnimplementedError();
  }

  @override
  Future<bool?> stopPreview(int deviceId) {
    // TODO: implement stopPreview
    throw UnimplementedError();
  }

  @override
  Future<String?> captureVideoStart(int deviceId) {
    // TODO: implement captureVideoStart
    throw UnimplementedError();
  }

  @override
  Future<bool?> captureVideoStop(int deviceId) {
    // TODO: implement captureVideoStop
    throw UnimplementedError();
  }

  @override
  Future<int?> getZoom(int deviceId) {
    // TODO: implement getZoom
    throw UnimplementedError();
  }

  @override
  Future<bool?> isCameraOpened(int deviceId) {
    // TODO: implement isCameraOpened
    throw UnimplementedError();
  }

  @override
  Future<bool?> isRecordVideo(int deviceId) {
    // TODO: implement isRecordVideo
    throw UnimplementedError();
  }

  @override
  Future<bool?> setZoom(int deviceId, int zoom) {
    // TODO: implement setZoom
    throw UnimplementedError();
  }
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
