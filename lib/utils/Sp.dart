
import 'package:shared_preferences/shared_preferences.dart';

class Sp{
  static set(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(value is String){
      sp.setString(key, value);
    }else if(value is int){
      sp.setInt(key, value);
    }else if(value is double){
      sp.setDouble(key, value);
    }else if(value is bool){
      sp.setBool(key, value);
    }
  }

  static get(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.get(key);
  }

  static remove(key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  static clear() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}