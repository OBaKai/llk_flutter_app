import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:llk_app/constants/Constants.dart';
import 'package:llk_app/utils/DataUtils.dart';
import 'package:llk_app/utils/LogUtils.dart';


class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage>{

  static final String TAG = 'LoginPageState';

  // 标记是否是加载中
  bool loading = true;
  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  // 是否解析了结果，这个字段用于确保parseResult方法只调用一次，真是MMP噢，不用这个字段标记，parseResult就调用了两次，导致黑屏产生，查黑屏问题用了我一天时间！
  bool parsedResult = false;
  // URL变化监听器
  StreamSubscription<String> _onUrlChanged;
  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state){
      switch(state.type){
        case WebViewState.shouldStart: // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad: // 开始加载

          break;
        case WebViewState.finishLoad: // 加载完成
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            parseResult();
          }
          break;
        case WebViewState.abortLoad: // 终止加载

          break;
      }
    });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((url) {
      // 登录成功会跳转到自定义的回调页面，该页面地址为http://yubo725.top/osc/osc.php?code=xxx
      // 该页面会接收code，然后根据code换取AccessToken，并将获取到的token及其他信息，通过js的get()方法返回
      if (url != null && url.length > 0 && url.contains('/logincallback?')) {
        isLoadingCallbackPage = true;
      }
    });
  }

  // 解析WebView中的数据，dart调用js代码的逻辑
  void parseResult() {
    if (parsedResult) {
      return;
    }
    parsedResult = true;
    flutterWebViewPlugin.evalJavascript("window.atob(get())").then((result) {
      // result json字符串，包含token信息
      if (result != null && result.length > 0) {
        // 拿到了js中的数据
        try {
          LogUtils.d(TAG, 'parseResult result=$result');
          // what the fuck?? need twice decode??
          var map = json.decode(result); // s is String
          if (map is String) {
            map = json.decode(map); // map is Map
          }
          if (map != null) {
            // 登录成功，取到了token，关闭当前页面
            DataUtils.saveLoginInfo(map);
            Navigator.pop(context, "refresh");
          }
        } catch (e) {
          LogUtils.d(TAG, "parse login result error: $e");
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];
    content.add(Text('登录开源中国',
      style: TextStyle(color: Colors.white),));
    if(loading){
      content.add(CupertinoActivityIndicator());
    }
    content.add(new Container(width: 50.0));

    return WebviewScaffold(
        key: _scaffoldKey,
        url: Constants.loginUrl,
//        withZoom: true,  // 允许网页缩放
//        withLocalStorage: true, // 允许LocalStorage
//        withJavascript: true, // 允许执行js代码
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: content,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      withZoom: true,  // 允许网页缩放
      withLocalStorage: true, // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}