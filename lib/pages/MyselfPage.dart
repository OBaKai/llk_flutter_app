import 'package:flutter/material.dart';
import 'package:llk_app/api/Api.dart';
import 'package:llk_app/constants/Constants.dart';
import 'package:llk_app/model/UserInfo.dart';
import 'package:llk_app/utils/DataUtils.dart';
import 'package:llk_app/utils/LogUtils.dart';
import 'package:llk_app/utils/NetUtils.dart';
import 'package:llk_app/utils/Sp.dart';
import 'package:llk_app/widgets/MyselfList.dart';

import 'LoginPage.dart';

class MyselfPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyselfPageState();
  }

}

class MyselfPageState extends State<MyselfPage>{
  static final String TAG = 'MyselfPageState';

  _login() async {
    // 打开登录页并处理登录成功的回调
    final result = await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));

    // result为"refresh"代表登录成功
    if (result != null && result == "refresh") {
      // 刷新用户信息
      _getUserInfo();
      // 通知动弹页面刷新
//      Constants.eventBus.fire(new LoginEvent());
    }
  }

  _getUserInfo(){
    String token = Sp.get(DataUtils.SP_AC_TOKEN);
    Map map = Map();
    map['access_token'] = token;
    NetUtils.get(Api.userInfo, params: map).then((data){
      if(data != null){
        UserInfo info = DataUtils.saveUserInfo(data);
        LogUtils.d(TAG, '!!!!!!!!!!!!!!!!!! = $info');
        myselfList.refreshUserInfo(info.avatar, info.name);
      }
    });
  }

  MyselfList myselfList = MyselfList();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Not>(
      onNotification: (notification){
        switch(notification.msg){
          case 'topClick':
            LogUtils.d(TAG, 'topClick');
            _login();
            break;
          case 'itemClick':
            LogUtils.d(TAG, 'itemClick index=${notification.index}');
            break;
        }

        return true;
      },
      child: myselfList,
    );
  }
}