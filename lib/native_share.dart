import 'dart:async';
import 'package:flutter/services.dart';

/// Plugin for summoning a platform share sheet.
class NativeShare {
  /// [MethodChannel] used to communicate with the platform side.
  static const MethodChannel _channel =
      const MethodChannel('plugin.persenlee.com/native_share');

  /// Summons the platform's share sheet to share text,url and image
  ///
  /// Wraps the platform's native share dialog. Can share a text , a URL ,an Image.
  /// It uses the ACTION_SEND Intent on Android and UIActivityViewController
  /// on iOS.
  ///
  /// parmams must not be null, the format like that {'title':'','url':'','image':''}
  /// title: [String]
  /// url: [String]
  /// image:  remote/local url [String]  
  /// 
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  static Future<int> share(Map<String, dynamic> params) async {
    var result = await _channel.invokeMethod('share', params);
    return result;
  }
}
