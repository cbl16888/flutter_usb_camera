
import 'flutter_usb_camera_platform_interface.dart';

class FlutterUsbCamera {

  FlutterUsbCamera() {
    FlutterUsbCameraPlatform.instance.setMessageHandler();
  }

  Future<String?> getPlatformVersion() {
    return FlutterUsbCameraPlatform.instance.getPlatformVersion();
  }

  Future<String?> takePicture(int deviceId) {
    return FlutterUsbCameraPlatform.instance.takePicture(deviceId);
  }

  Future<String?> captureVideoStart(int deviceId) {
    return FlutterUsbCameraPlatform.instance.captureVideoStart(deviceId);
  }

  Future<bool?> captureVideoStop(int deviceId) {
    return FlutterUsbCameraPlatform.instance.captureVideoStop(deviceId);
  }

  Future<bool?> isCameraOpened(int deviceId) {
    return FlutterUsbCameraPlatform.instance.isCameraOpened(deviceId);
  }

  Future<bool?> isRecordVideo(int deviceId) {
    return FlutterUsbCameraPlatform.instance.isRecordVideo(deviceId);
  }

  Future<int?> getZoom(int deviceId) {
    return FlutterUsbCameraPlatform.instance.getZoom(deviceId);
  }

  Future<bool?> setZoom(int deviceId, int zoom) {
    return FlutterUsbCameraPlatform.instance.setZoom(deviceId, zoom);
  }

  Future<bool?> startPreview(int deviceId) {
    return FlutterUsbCameraPlatform.instance.startPreview(deviceId);
  }

  Future<bool?> stopPreview(int deviceId) {
    return FlutterUsbCameraPlatform.instance.stopPreview(deviceId);
  }

  Stream<USBCameraEvent> get events => FlutterUsbCameraPlatform.instance.events;
}
