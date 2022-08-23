package com.zly.usbcamera.flutter_usb_camera;

import android.content.Context;
import android.hardware.usb.UsbDevice;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.jiangdg.ausbc.MultiCameraClient;
import com.serenegiant.usb.USBMonitor;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class UsbCameraViewFactory  extends PlatformViewFactory {

    private final MultiCameraClient.Camera camera;

    /**
     * @param createArgsCodec the codec used to decode the args parameter of {@link #create}.
     */
    public UsbCameraViewFactory(@Nullable MessageCodec<Object> createArgsCodec, Context context, MethodChannel channel, UsbDevice usbDevice) {
        super(createArgsCodec);
        camera = new MultiCameraClient.Camera(context, usbDevice);
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        return null;
    }



    public void onCameraAttached() {

    }

    public void onCameraDetached() {
        camera.setUsbControlBlock(null);
    }

    public void onCameraDisConnected(USBMonitor.UsbControlBlock usbControlBlock) {
        camera.setUsbControlBlock(usbControlBlock);
        this.onCameraDisConnected();
    }

    public void onCameraDisConnected() {

    }
}
