import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_usb_camera/flutter_usb_camera.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterUsbCameraPlugin = FlutterUsbCamera();
  late StreamSubscription _usbCameraBus;
  int cameraCount = 0;
  String logStr = "";
  bool isShowLog = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _usbCameraBus = _flutterUsbCameraPlugin.events.listen((event) {
      if (event.event == USBCameraEvent.onUsbCameraChanged) {
        setState(() {
          cameraCount = event.count ?? 0;
        });
      } else if (event.event == USBCameraEvent.onLogChanged) {
        setState(() {
          logStr = event.logString ?? "";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usbCameraBus.cancel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterUsbCameraPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowLog = !isShowLog;
                  });
                },
                child: Text(
                  isShowLog ? '隐藏日志' : '显示日志',
                  style: const TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Text("$cameraCount"),
                Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
                TextButton(
                    onPressed: () {
                      _flutterUsbCameraPlugin.takePicture("deviceId");
                    },
                    child: const Text('拍照')),
              ],
            ),
            isShowLog
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: SingleChildScrollView(
                      child: Text(logStr),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
