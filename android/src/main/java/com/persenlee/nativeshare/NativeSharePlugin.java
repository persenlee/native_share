package com.persenlee.nativeshare;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.content.Intent;

/** NativeSharePlugin */
public class NativeSharePlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugin.persenlee.com/native_share");
    channel.setMethodCallHandler(new NativeSharePlugin(registrar));
  }

  private final Registrar registrar;

  private NativeSharePlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("share")){
      String title = call.argument("title");
      String url = call.argument("url");
      share(title,url);
    } else {
      result.notImplemented();
    }
  }

  private void share(String text,String url) {
    if (text == null || text.isEmpty()) {
        throw new IllegalArgumentException("Non-empty text expected");
    }

    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_TEXT, text);
    shareIntent.putExtra(Intent.EXTRA_STREAM,url);
    shareIntent.setType("text/plain");
    if (registrar.activity() == null) {
      shareIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      registrar.context().startActivity(shareIntent);
  } else {
      registrar.activity().startActivity(shareIntent);
  }
}
}
