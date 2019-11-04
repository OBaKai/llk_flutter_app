import 'package:flutter/services.dart';

class LogUtils {
  static const perform = const MethodChannel("android_log");

  static const String TAG = 'LLK';

  static void v(String tag, String msg) {
    perform.invokeMethod('logV', {'tag': TAG, 'msg': _msg(tag, msg)});
  }

  static void d(String tag, String msg) {
    perform.invokeMethod('logD', {'tag': TAG, 'msg': _msg(tag, msg)});
  }

  static void i(String tag, String msg) {
    perform.invokeMethod('logI', {'tag': TAG, 'msg': _msg(tag, msg)});
  }

  static void w(String tag, String msg) {
    perform.invokeMethod('logW', {'tag': TAG, 'msg': _msg(tag, msg)});
  }

  static void e(String tag, String msg) {
    perform.invokeMethod('logE', {'tag': TAG, 'msg': _msg(tag, msg)});
  }

  static String _msg(tag, msg) =>
      '[$tag]: $msg';
}