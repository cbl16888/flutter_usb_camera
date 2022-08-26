package com.zly.usbcamera.flutter_usb_camera;

import android.content.Context;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.hardware.usb.UsbDevice;
import android.os.Build;
import android.os.Environment;
import android.provider.SyncStateContract;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.jiangdg.ausbc.MultiCameraClient;
import com.jiangdg.ausbc.callback.ICaptureCallBack;
import com.jiangdg.ausbc.callback.IPreviewDataCallBack;
import com.jiangdg.natives.YUVUtils;
import com.serenegiant.usb.USBMonitor;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class UsbCameraViewFactory  extends PlatformViewFactory {

    private MultiCameraClient.Camera camera;
    public int mViewId;
    private MethodChannel channel;
    private UsbDevice usbDevice;
    public UsbCameraView mUvcCameraView;
    private Context context;
    private byte[] previewData;

    /**
     * @param createArgsCodec the codec used to decode the args parameter of {@link #create}.
     */
    public UsbCameraViewFactory(@Nullable MessageCodec<Object> createArgsCodec, Context context, MethodChannel channel, @Nullable UsbDevice usbDevice) {
        super(createArgsCodec);
        this.channel = channel;
        this.context = context;
        if (null != usbDevice) {
            camera = new MultiCameraClient.Camera(context, usbDevice);
            this.usbDevice = usbDevice;
            IPreviewDataCallBack callBack = new IPreviewDataCallBack() {
                @Override
                public void onPreviewData(@Nullable byte[] bytes, @NonNull DataFormat dataFormat) {
//                    DebugLog.log(Arrays.toString(bytes));
//                    DebugLog.log(String.valueOf(dataFormat));
                    Log.i("info", Arrays.toString(bytes));
                    previewData = bytes;
                }
            };
            camera.addPreviewDataCallBack(callBack);
        }
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        mViewId = viewId;
        mUvcCameraView = new UsbCameraView(context, channel);
        return mUvcCameraView;
    }



    public void onCameraAttached() {

    }

    public void onCameraDetached() {
        if (null != camera) {
            camera.setUsbControlBlock(null);
        }
    }

    public void onCameraDisConnected(USBMonitor.UsbControlBlock usbControlBlock) {
        camera.setUsbControlBlock(usbControlBlock);
        this.onCameraDisConnected();
    }

    public void onCameraDisConnected() {

    }

    public String getPicturePath() {
        String mFile = null;
        if (context == null) {
            return "";
        }
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
        String now = df.format(System.currentTimeMillis());
        String path = context.getExternalFilesDir(null) + "/UsbCamera";
        mFile = context.getExternalFilesDir(null) + "/UsbCamera/" + now + ".jpg";
        File filePath = new File(path);
        if (!filePath.exists()) {
            filePath.mkdirs();
        }
        return mFile;
    }


        public void takePicture() {
        if (null != camera) {
            DebugLog.log("开始拍照");
            save();
//            camera.captureImage(new ICaptureCallBack() {
//                @Override
//                public void onError(@Nullable String s) {
//                    Log.i("info", "拍照失败" + s);
//                    DebugLog.log("拍照失败" + s);;
//                }
//
//                @Override
//                public void onComplete(@Nullable String s) {
//                    Log.i("info", "拍照完成" + s);
//                    DebugLog.log("拍照完成: " + s);
//                }
//
//                @Override
//                public void onBegin() {
//
//                }
//            }, getPicturePath());
        } else {
            DebugLog.log("开始拍照,相机为空");
        }
    }

    public void save() {
        if (null == previewData) {
            return;
        }
        String fileName = System.currentTimeMillis() + ".jpg";  //jpeg文件名定义
        String path = context.getExternalFilesDir(null) + "/UsbCamera";
        String mFile = context.getExternalFilesDir(null) + "/UsbCamera/" + fileName;
        File filePath = new File(path);
        if (!filePath.exists()) {
            filePath.mkdirs();
        }
        File pictureFile = new File(mFile);
        if (!pictureFile.exists()) {
            try {
                pictureFile.createNewFile();
                FileOutputStream filecon = new FileOutputStream(pictureFile);
                YuvImage image = new YuvImage(previewData, ImageFormat.NV21, 1280, 720, null);   //将NV21 data保存成YuvImage
                //图像压缩
                image.compressToJpeg(
                        new Rect(0, 0, image.getWidth(), image.getHeight()),
                        100, filecon);   // 将NV21格式图片，以质量70压缩成Jpeg，并得到JPEG数据流
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    public void startPreview() {
        if (null != camera) {
            camera.openCamera(mUvcCameraView.mUVCCameraView, null);
            DebugLog.log("开始展示");
        } else {
            DebugLog.log("开始展示,相机为空");
        }
    }

    public void stopPreview() {
        if (null != camera) {
            camera.closeCamera();
            DebugLog.log("结束展示");
        } else {
            DebugLog.log("结束展示,相机为空");
        }
    }
}
