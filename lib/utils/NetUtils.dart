import 'package:http/http.dart' as http;

class NetUtils{
  static Future<String> get(String url, {Map<String, String> params}) async {
    if(params != null && params.isNotEmpty){
      StringBuffer sb = new StringBuffer('?');
      params.forEach((key, value){
        sb.write('$key=$value&');
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }

    http.Response response = await http.get(url);
    return response.body;
  }

  static Future<String> post(String url, {Map<String, String> params}) async {
    http.Response response = await http.put(url, body: params);
    return response.body;
  }
}