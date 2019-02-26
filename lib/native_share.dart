import 'dart:async';

import 'package:flutter/services.dart';


class NativeShare {
  static const MethodChannel _channel =
      const MethodChannel('plugin.persenlee.com/native_share');

  static Future<int> share(Map<String,dynamic> params) async{
     final int result = await _channel.invokeMethod('share',params);
      return result;
  }
}
