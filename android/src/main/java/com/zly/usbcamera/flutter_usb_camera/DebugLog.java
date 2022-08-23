package com.zly.usbcamera.flutter_usb_camera;

import java.text.SimpleDateFormat;

import io.flutter.plugin.common.MethodChannel;

public class DebugLog {
    private static String logString = "";
    static MethodChannel channel;

    static void log(String log) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
        String now = df.format(System.currentTimeMillis());
        logString += now + ":" + log + "\n";
        channel.invokeMethod("onLogChanged", logString);
    }

    static void clearLog() {
        logString = "";
        channel.invokeMethod("onLogChanged", logString);
    }
}
