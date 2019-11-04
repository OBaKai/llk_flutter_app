
// 用户信息
import 'dart:convert';

class UserInfo {

  String gender;
  String name;
  String location;
  num id;
  String avatar;
  String email;
  String url;

  UserInfo({this.id, this.name, this.gender, this.avatar, this.email, this.location, this.url});

  UserInfo.fromJson(Map<String, dynamic> json)
      : gender = json['gender'],
        name = json['name'],
        location = json['location'],
        id = json['id'],
        avatar = json['avatar'],
        email = json['email'],
        url = json['url'];

  Map<String, dynamic> toJson() =>
      {
        'gender': gender,
        'name': name,
        'location': location,
        'id': id,
        'avatar': avatar,
        'email': email,
        'url': url,
      };

  @override
  String toString() {
    return 'UserInfo: ${json.encode(toJson())}';
  }
}