import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_usb_camera_platform_interface.dart';

/// An implementation of [FlutterUsbCameraPlatform] that uses method channels.
class MethodChannelFlutterUsbCamera extends FlutterUsbCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_usb_camera');
  late StreamController<USBCameraEvent> _streamController;
  @override
  Stream<USBCameraEvent> get events => _streamController.stream;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> takePicture(int deviceId) async {
    final path =
        await methodChannel.invokeMethod<String>('takePicture', deviceId);
    return path;
  }

  @override
  Future<String?> captureVideoStart(int deviceId) async {
    final path =
        await methodChannel.invokeMethod<String>('captureVideoStart', deviceId);
    return path;
  }

  @override
  Future<bool?> captureVideoStop(int deviceId) async {
    final isSuccess =
        await methodChannel.invokeMethod<bool>('captureVideoStop', deviceId);
    return isSuccess;
  }

  @override
  Future<bool?> isCameraOpened(int deviceId) async {
    final isOpened =
    await methodChannel.invokeMethod<bool>('isCameraOpened', deviceId);
    return isOpened;
  }

  @override
  Future<bool?> isRecordVideo(int deviceId) async {
    final isRecord =
    await methodChannel.invokeMethod<bool>('isRecordVideo', deviceId);
    return isRecord;
  }

  @override
  Future<int?> getZoom(int deviceId) async {
    final zoom =
    await methodChannel.invokeMethod<int>('getZoom', deviceId);
    return zoom;
  }

  @override
  Future<bool?> setZoom(int deviceId, int zoom) async {
    final isSuccess =
    await methodChannel.invokeMethod<bool>('setZoom', {"deviceId": deviceId, "zoom": zoom});
    return isSuccess;
  }

  @override
  Future<bool?> startPreview(int deviceId) async {
    final isSuccess =
        await methodChannel.invokeMethod<bool>('startPreview', deviceId);
    return isSuccess;
  }

  @override
  Future<bool?> stopPreview(int deviceId) async{
    final isSuccess =
        await methodChannel.invokeMethod<bool>('stopPreview', deviceId);
    return isSuccess;
  }

  @override
  void setMessageHandler() {
    _streamController = StreamController<USBCameraEvent>.broadcast();
    methodChannel.setMethodCallHandler((call) {
      switch (call.method) {
        case USBCameraEvent.onUsbCameraChanged:
          if (kDebugMode) {
            print(call);
          }
          _streamController.sink.add(USBCameraEvent(call.method, count: call.arguments));
          break;
        case USBCameraEvent.onLogChanged:
          _streamController.sink.add(USBCameraEvent(call.method, logString: call.arguments));
          break;
        default:
          if (kDebugMode) {
            print("unKnow method: ${call.method}");
          }
          break;
      }
      return Future.value(true);
    });
  }
}
