import 'dart:convert';

import 'package:llk_app/model/UserInfo.dart';

import 'Sp.dart';

class DataUtils{
  static final String SP_AC_TOKEN = "accessToken";
  static final String SP_RE_TOKEN = "refreshToken";
  static final String SP_UID = "uid";
  static final String SP_IS_LOGIN = "isLogin"; // SP_IS_LOGIN标记是否登录
  static final String SP_EXPIRES_IN = "expiresIn";
  static final String SP_TOKEN_TYPE = "tokenType";

  static final String SP_USERINFO = "userinfo";

  // 保存用户登录信息，data中包含了token等信息
  static saveLoginInfo(Map data) {
    if (data != null) {
      String accessToken = data['access_token'];
      Sp.set(SP_AC_TOKEN, accessToken);
      String refreshToken = data['refresh_token'];
      Sp.set(SP_RE_TOKEN, refreshToken);
      num uid = data['uid'];
      Sp.set(SP_UID, uid);
      String tokenType = data['tokenType'];
      Sp.set(SP_TOKEN_TYPE, tokenType);
      num expiresIn = data['expires_in'];
      Sp.set(SP_EXPIRES_IN, expiresIn);

      Sp.set(SP_IS_LOGIN, true); // SP_IS_LOGIN标记是否登录
    }
  }

  static clearLoginInfo(){
    Sp.remove(SP_AC_TOKEN);
    Sp.remove(SP_RE_TOKEN);
    Sp.remove(SP_UID);
    Sp.remove(SP_TOKEN_TYPE);
    Sp.remove(SP_EXPIRES_IN);
    Sp.remove(SP_IS_LOGIN);
  }

  //保存用户个人信息
  static UserInfo saveUserInfo(String jsonData) {
    if (jsonData != null) {
      Sp.set(SP_USERINFO, jsonData);
      UserInfo userInfo = UserInfo.fromJson(json.decode(jsonData));
      return userInfo;
    }
    return null;
  }

  // 获取用户信息
  static UserInfo getUserInfo() {
    bool isLogin = Sp.get(SP_IS_LOGIN);
    if (isLogin == null || !isLogin) {
      return null;
    }

    String jsonData = Sp.get(SP_USERINFO);
    if(jsonData != null){
      UserInfo userInfo = UserInfo.fromJson(json.decode(jsonData));
      return userInfo;
    }

    return null;
  }

  static clearUserInfo(){
    Sp.remove(SP_USERINFO);
  }

  // 是否登录
  static Future<bool> isLogin() async {
    bool b = Sp.get(SP_IS_LOGIN);
    return b != null && b;
  }

  // 获取accesstoken
  static Future<String> getAccessToken() async {
    return Sp.get(SP_AC_TOKEN);
  }

}