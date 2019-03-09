package com.persenlee.nativeshare;

import androidx.core.app.ShareCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry;

import android.Manifest;
import android.content.Intent;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.net.Uri;
import android.content.pm.PackageManager;
import java.io.*;

import android.graphics.Bitmap;
import android.os.Environment;
import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiskCache;
import com.nostra13.universalimageloader.cache.disc.naming.HashCodeFileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.decode.BaseImageDecoder;
import com.nostra13.universalimageloader.core.download.BaseImageDownloader;


/** NativeSharePlugin */
public class NativeSharePlugin implements MethodCallHandler,PluginRegistry.RequestPermissionsResultListener {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugin.persenlee.com/native_share");
    channel.setMethodCallHandler(new NativeSharePlugin(registrar));
  }

  private final Registrar registrar;
  private String title,url,imageUrl;
  private NativeSharePlugin(Registrar registrar) {
    this.registrar = registrar;
    registrar.addRequestPermissionsResultListener(this);
    configImageLoader();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("share")){
      title = call.argument("title");
      url = call.argument("url");
      imageUrl = call.argument("image");
      share(title,url,imageUrl);
    } else {
      result.notImplemented();
    }
  }

  private void share(String text,String url,String imageUrl) {
    if (text == null || text.isEmpty()) {
        throw new IllegalArgumentException("Non-empty text expected");
    }
    try {
      if (imageUrl != null && imageUrl.trim().length() > 0) {
        cheekPermission();
      } else {
        _share(null);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

}

private  void _share(Uri imageUri) {
    Intent shareIntent = new Intent();
    if (imageUri != null){
      shareIntent = ShareCompat.IntentBuilder
              .from(registrar.activity())
              .setText(title + "\n" + url)
              .setType("image/jpeg").setStream(imageUri).getIntent();
    } else {
      shareIntent = ShareCompat.IntentBuilder
              .from(registrar.activity())
              .setText(title + "\n" + url)
              .setType("image/jpeg").getIntent();
    }
  if (registrar.activity() == null) {
    shareIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    registrar.context().startActivity(shareIntent);
  } else {
    registrar.activity().startActivity(shareIntent);
  }
}

  public Uri getUriFromUrl(String thisUrl) {
    try {
      StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
      StrictMode.setThreadPolicy(policy);
      Bitmap inImage = ImageLoader.getInstance().loadImageSync(thisUrl);
      ByteArrayOutputStream bytes = new ByteArrayOutputStream();
      inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
      String path = MediaStore.Images.Media.insertImage(
              registrar.context().getContentResolver(), inImage, "shared_image", null);
      return Uri.parse(path);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  private static final int MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE= 0;

  private void cheekPermission(){
    if (registrar.context().checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            != PackageManager.PERMISSION_GRANTED) {

      // Should we show an explanation?
      if (registrar.activity().shouldShowRequestPermissionRationale(
              Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
        // Explain to the user why we need to read the contacts
      }

      registrar.activity().requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
              MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);

      return;
    } else {
      Uri uri =  getUriFromUrl(imageUrl);
      _share(uri);
    }
  }


  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    boolean permissionGranted =
            grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;

    if (permissionGranted) {
      Uri uri =  getUriFromUrl(imageUrl);
      _share(uri);
    } else {
      _share(null);
    }
    return true;
  }


  private void configImageLoader(){
    File cacheFile = new File(Environment.getExternalStorageDirectory() + "/" + "imgages");
//    File cacheDir = StorageUtils.getCacheDirectory(registrar.context());
    ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(registrar.context())
            .memoryCacheExtraOptions(480, 800) // default = device screen dimensions
            .diskCacheExtraOptions(480, 800, null)
		    .threadPoolSize(3) // default
            .threadPriority(Thread.NORM_PRIORITY - 2) // default
            .tasksProcessingOrder(QueueProcessingType.FIFO) // default
            .denyCacheImageMultipleSizesInMemory()
            .memoryCache(new LruMemoryCache(2 * 1024 * 1024))
            .memoryCacheSize(2 * 1024 * 1024)
            .memoryCacheSizePercentage(13) // default
            .diskCache(new UnlimitedDiskCache(cacheFile)) // default
            .diskCacheSize(50 * 1024 * 1024)
            .diskCacheFileCount(100)
            .diskCacheFileNameGenerator(new HashCodeFileNameGenerator()) // default
            .imageDownloader(new BaseImageDownloader(registrar.context())) // default
            .imageDecoder(new BaseImageDecoder(true)) // default
            .defaultDisplayImageOptions(DisplayImageOptions.createSimple()) // default
            .writeDebugLogs()
            .build();
    ImageLoader.getInstance().init(config);
  }
}
