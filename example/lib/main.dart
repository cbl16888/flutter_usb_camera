import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_usb_camera/flutter_usb_camera.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

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
  int deviceId = 0;
  String logStr = "";
  bool isShowLog = false;
  bool isWorking = false;
  bool isRecord = false;
  bool isTaking = false;
  int zoom = 0;
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _usbCameraBus = _flutterUsbCameraPlugin.events.listen((event) {
      if (event.event == USBCameraEvent.onUsbCameraChanged) {
        deviceId = event.count ?? 0;
        if (deviceId == 0) {
          isWorking = false;
          isRecord = false;
          isTaking = false;
          isOpened = false;
          zoom = 0;
        }
        setState(() {});
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
                  isShowLog ? '????????????' : '????????????',
                  style: const TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("??????: $deviceId  ${deviceId > 0 ? "?????????" : "?????????"}  "),
                    Text(
                      "??????: ${isWorking ? "?????????" : "?????????"}  ",
                      style: TextStyle(
                          color: isWorking ? Colors.red : Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "??????: ${isTaking ? "?????????" : "?????????"}  ",
                      style: TextStyle(
                          color: isTaking ? Colors.red : Colors.black),
                    ),
                    Text(
                      "??????: ${isRecord ? "?????????" : "?????????"}  ",
                      style: TextStyle(
                          color: isRecord ? Colors.red : Colors.black),
                    ),
                    Text("??????: $zoom  ")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (isWorking) {
                            return;
                          }
                          PermissionStatus status =
                              await Permission.camera.request();
                          if (status == PermissionStatus.granted) {
                            // status = await Permission.locationWhenInUse.request();
                            // if (status == PermissionStatus.granted) {
                            setState(() {
                              isWorking = true;
                            });
                            _flutterUsbCameraPlugin.startPreview(deviceId);
                            // }
                          }
                        },
                        child: const Text('????????????')),
                    TextButton(
                        onPressed: () {
                          if (!isWorking) {
                            return;
                          }
                          setState(() {
                            isWorking = false;
                          });
                          _flutterUsbCameraPlugin.stopPreview(deviceId);
                        },
                        child: const Text('????????????')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (isTaking || !isWorking) {
                            return;
                          }
                          bool? isOpened = await _flutterUsbCameraPlugin
                              .isCameraOpened(deviceId);
                          if (isOpened == true) {
                            PermissionStatus status =
                                await Permission.storage.request();
                            if (status == PermissionStatus.granted) {
                              // status = await Permission.locationWhenInUse.request();
                              // if (status == PermissionStatus.granted) {
                              setState(() {
                                isTaking = true;
                              });
                              _flutterUsbCameraPlugin
                                  .takePicture(deviceId)
                                  .then((value) {
                                if (kDebugMode) {
                                  print("????????????: $value");
                                }
                              }).catchError((onError) {
                                if (kDebugMode) {
                                  print("????????????: ${onError.toString}");
                                }
                              }).whenComplete(() {
                                setState(() {
                                  isTaking = false;
                                });
                              });
                              // }
                            }
                          }
                        },
                        child: const Text('??????')),
                    TextButton(
                        onPressed: () async {
                          if (isRecord || !isWorking || isTaking) {
                            return;
                          }
                          bool? isOpened = await _flutterUsbCameraPlugin
                              .isCameraOpened(deviceId);
                          if (isOpened == true) {
                            bool? isRecording = await _flutterUsbCameraPlugin
                                .isRecordVideo(deviceId);
                            if (isRecording == false) {
                              PermissionStatus status =
                                  await Permission.storage.request();
                              if (status == PermissionStatus.granted) {
                                status =
                                await Permission.microphone.request();
                              }
                              if (status == PermissionStatus.granted) {
                                // status = await Permission.locationWhenInUse.request();
                                // if (status == PermissionStatus.granted) {
                                setState(() {
                                  isRecord = true;
                                });
                                _flutterUsbCameraPlugin
                                    .captureVideoStart(deviceId)
                                    .then((value) {
                                  if (kDebugMode) {
                                    print("??????????????????: $value");
                                  }
                                }).catchError((onError) {
                                  if (kDebugMode) {
                                    print("??????????????????: ${onError.toString}");
                                  }
                                  setState(() {
                                    isRecord = false;
                                  });
                                });
                                // }
                              }
                            } else if (isRecording == true) {
                              setState(() {
                                isRecord = true;
                              });
                            }
                          }
                        },
                        child: const Text('????????????')),
                    TextButton(
                        onPressed: () {
                          if (isRecord) {
                            setState(() {
                              isRecord = false;
                            });
                            _flutterUsbCameraPlugin.captureVideoStop(deviceId);
                          }
                        },
                        child: const Text('????????????')),
                    TextButton(
                        onPressed: () async {
                          if (isWorking) {
                            bool? isOpened = await _flutterUsbCameraPlugin
                                .isCameraOpened(deviceId);
                            if (isOpened == true) {
                              int? zoomValue = await _flutterUsbCameraPlugin
                                  .getZoom(deviceId);
                              setState(() {
                                zoom = zoomValue ?? 0;
                              });
                            }
                          }
                        },
                        child: const Text('????????????')),
                    TextButton(
                        onPressed: () async {
                          if (isWorking && !isTaking && !isRecord) {
                            bool? isOpened = await _flutterUsbCameraPlugin
                                .isCameraOpened(deviceId);
                            if (isOpened == true) {
                              bool? isSuccess = await _flutterUsbCameraPlugin
                                  .setZoom(deviceId, zoom + 1);
                              if (isSuccess == true) {
                                setState(() {
                                  zoom += 1;
                                });
                              }
                            }
                          }
                        },
                        child: const Text('????????????')),
                  ],
                ),
                Container(
                  width: 350,
                  height: 350,
                  // color: Colors.red.withOpacity(0.2),
                  child: deviceId > 0
                      ? AndroidView(
                          viewType: deviceId.toString(),
                        )
                      : null,
                )
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
