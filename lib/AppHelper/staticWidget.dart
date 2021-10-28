import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'AppController.dart';

class staticWidget {


  String namevalid(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.pleaseEnterYourName}";
    }
    if (val.length > 60) {
      return "${AppController.strings.pleaseEnterRealName}";
    }
  }
  String validEmpty(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.pleaseFilltheData}";
    }
  }

  String emailvalid(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.pleaseEnterYourEmail}";
    }
    if (EmailValidator.validate(val) == false) {
      return "${AppController.strings.enterValedEmail}";
    }
  }

  String passwordValid(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.enterpassword}";
    }
    if (val.length <= 6) {
      return "${AppController.strings.passwordLess6}";
    }
  }

  String phoneValid(String val) {
    if (val.trim().isEmpty) {
      return "${AppController.strings.errorPhone}";
    }
    if (val.length != 10) {
      return "${AppController.strings.phoneNumValid}";
    }
  }
}

