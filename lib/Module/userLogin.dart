import 'package:flutter/material.dart';

class UserLogin{
  String id;
  String email;
  String password;


  UserLogin({this.id,  this.email, this.password,});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,

    );
  }
}