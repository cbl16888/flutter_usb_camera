package com.zly.usbcamera.flutter_usb_camera;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.TextureView;
import android.view.View;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class UsbCameraView implements PlatformView {

    private MethodChannel mChannel;
    public TextureView mUVCCameraView;
    private Boolean isPreview = false;
    private View mNativeView;

    public UsbCameraView(Context context, MethodChannel channel) {
        mChannel = channel;
        mNativeView = LayoutInflater.from(context).inflate(R.layout.camera_view, null, false);
        mUVCCameraView = mNativeView.findViewById(R.id.texture_view);
    }

    @Nullable
    @Override
    public View getView() {
        return mNativeView;
    }

    @Override
    public void dispose() {

    }
}
