
import 'flutter_usb_camera_platform_interface.dart';

class FlutterUsbCamera {

  FlutterUsbCamera() {
    FlutterUsbCameraPlatform.instance.setMessageHandler();
  }

  Future<String?> getPlatformVersion() {
    return FlutterUsbCameraPlatform.instance.getPlatformVersion();
  }

  Future<bool?> takePicture(int deviceId) {
    return FlutterUsbCameraPlatform.instance.takePicture(deviceId);
  }

  Future<bool?> startPreview(int deviceId) {
    return FlutterUsbCameraPlatform.instance.startPreview(deviceId);
  }

  Future<bool?> stopPreview(int deviceId) {
    return FlutterUsbCameraPlatform.instance.stopPreview(deviceId);
  }

  Stream<USBCameraEvent> get events => FlutterUsbCameraPlatform.instance.events;
}
