import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_usb_camera_platform_interface.dart';

/// An implementation of [FlutterUsbCameraPlatform] that uses method channels.
class MethodChannelFlutterUsbCamera extends FlutterUsbCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_usb_camera');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
