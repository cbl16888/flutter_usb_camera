
import 'flutter_usb_camera_platform_interface.dart';

class FlutterUsbCamera {

  FlutterUsbCamera() {
    FlutterUsbCameraPlatform.instance.setMessageHandler();
  }

  Future<String?> getPlatformVersion() {
    return FlutterUsbCameraPlatform.instance.getPlatformVersion();
  }

  Future<bool?> takePicture(String deviceId) {
    return FlutterUsbCameraPlatform.instance.takePicture(deviceId);
  }

  Stream<USBCameraEvent> get events => FlutterUsbCameraPlatform.instance.events;
}
