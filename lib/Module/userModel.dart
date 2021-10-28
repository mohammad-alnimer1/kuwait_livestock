import 'dart:typed_data';

class userModel{
  String result;
  String message;
  String name;
  String login;
  String password;
  int user_id;

  toJson(){
    return {
      'result':result,
      'name':name.toString(),
      'login':login.toString(),
      'password':password,
      'user_id':user_id.toString(),
    };
  }

}