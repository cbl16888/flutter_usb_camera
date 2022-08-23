
import 'flutter_usb_camera_platform_interface.dart';

class FlutterUsbCamera {
  Future<String?> getPlatformVersion() {
    return FlutterUsbCameraPlatform.instance.getPlatformVersion();
  }
}
