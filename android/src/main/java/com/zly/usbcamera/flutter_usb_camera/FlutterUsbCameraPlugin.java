package com.zly.usbcamera.flutter_usb_camera;

import android.content.Context;
import android.hardware.usb.UsbDevice;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.jiangdg.ausbc.MultiCameraClient;
import com.jiangdg.ausbc.callback.IDeviceConnectCallBack;
import com.serenegiant.usb.USBMonitor;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMessageCodec;

/** FlutterUsbCameraPlugin */
public class FlutterUsbCameraPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private MultiCameraClient mCameraClient;
  private final Map<Integer, UsbCameraViewFactory> mFactoryMap = new HashMap<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_usb_camera");
    DebugLog.channel = channel;
    channel.setMethodCallHandler(this);
    Context context = flutterPluginBinding.getApplicationContext();
    IDeviceConnectCallBack callback = new IDeviceConnectCallBack() {
      @Override
      public void onAttachDev(@Nullable UsbDevice usbDevice) {
        if (usbDevice == null) {
          return;
        }
        DebugLog.log("发现设备:" + usbDevice.getDeviceId() + usbDevice.getDeviceName() + usbDevice.toString());
        if (!mFactoryMap.containsKey(usbDevice.getDeviceId())) {
          Boolean hasPermission = mCameraClient.requestPermission(usbDevice);
          DebugLog.log("请求权限:" + hasPermission);
          if (Boolean.TRUE.equals(hasPermission)) {
            UsbCameraViewFactory factory = new UsbCameraViewFactory(StandardMessageCodec.INSTANCE, context, channel, usbDevice);
            mFactoryMap.put(usbDevice.getDeviceId(), factory);
            factory.onCameraAttached();
            channel.invokeMethod("onUsbCameraChanged", mFactoryMap.size());
          }
        } else {
          DebugLog.log("设备已添加:" + usbDevice.getDeviceId());
        }
      }

      @Override
      public void onDetachDec(@Nullable UsbDevice usbDevice) {
        if (null != usbDevice) {
          UsbCameraViewFactory factory = mFactoryMap.remove(usbDevice.getDeviceId());
          if (null != factory) {
            factory.onCameraDetached();
            channel.invokeMethod("onUsbCameraChanged", mFactoryMap.size());
          }
        }
      }

      @Override
      public void onConnectDev(@Nullable UsbDevice usbDevice, @Nullable USBMonitor.UsbControlBlock usbControlBlock) {
        if (null == usbDevice || null == usbControlBlock) {
          return;
        }
        UsbCameraViewFactory factory = mFactoryMap.get(usbDevice.getDeviceId());
        if (null != factory) {
          factory.onCameraDisConnected(usbControlBlock);
        }
      }

      @Override
      public void onDisConnectDec(@Nullable UsbDevice usbDevice, @Nullable USBMonitor.UsbControlBlock usbControlBlock) {
        if (null == usbDevice) {
          return;
        }
        UsbCameraViewFactory factory = mFactoryMap.get(usbDevice.getDeviceId());
        if (null != factory) {
          factory.onCameraDisConnected();
        }
      }

      @Override
      public void onCancelDev(@Nullable UsbDevice usbDevice) {
        if (null == usbDevice) {
          return;
        }
        UsbCameraViewFactory factory = mFactoryMap.get(usbDevice.getDeviceId());
        if (null != factory) {
          factory.onCameraDisConnected();
        }
      }
    };
    mCameraClient = new MultiCameraClient(context, callback);
    mCameraClient.register();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("takePicture")) {
      String deviceId = (String) call.arguments;
//      mUvcCameraFactory.takePicture();
      Log.d("info", deviceId);
      result.success(true);
    } else if (call.method.equals("clearLog")) {
      DebugLog.clearLog();
      result.success(true);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    mCameraClient.unRegister();
    mCameraClient.destroy();
    mCameraClient = null;
  }
}
