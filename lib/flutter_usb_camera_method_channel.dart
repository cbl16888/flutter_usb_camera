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
  Future<bool?> takePicture(String deviceId) async {
    final isSuccess =
        await methodChannel.invokeMethod<bool>('takePicture', deviceId);
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
