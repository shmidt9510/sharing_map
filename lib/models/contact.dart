import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum UserContactType { TELEGRAM, WHATSAPP, PHONE, ERROR }

extension UserContactTypeString on String {
  UserContactType get userContact {
    switch (this) {
      case 'TELEGRAM':
        return UserContactType.TELEGRAM;
      case 'WHATSAPP':
        return UserContactType.WHATSAPP;
      case 'PHONE':
        return UserContactType.PHONE;
      case 'ERROR':
        return UserContactType.ERROR;
    }
    return UserContactType.ERROR;
  }
}

class UserContact {
  final String? id;
  final String contact;
  final UserContactType type;
  UserContact(
      {this.id, required this.contact, this.type = UserContactType.TELEGRAM});

  factory UserContact.fromJson(Map<String, dynamic> json) => UserContact(
      id: json["id"],
      contact: json["contact"],
      type: json["type"].toString().userContact);

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact": contact,
        "type": type.name.toString(),
      };
}

extension UserIcon on UserContact {
  IconData get contactIcon {
    switch (this.type) {
      case UserContactType.TELEGRAM:
        return FontAwesomeIcons.telegram;
      case UserContactType.WHATSAPP:
        return FontAwesomeIcons.whatsapp;
      case UserContactType.PHONE:
        return FontAwesomeIcons.phone;
      case UserContactType.ERROR:
        return Icons.error;
    }
  }
}

extension ContactString on UserContact {
  String get getUri {
    switch (this.type) {
      case UserContactType.TELEGRAM:
        return "https://t.me/";
      case UserContactType.WHATSAPP:
        return "whatsapp://send?phone=";
      case UserContactType.PHONE:
        return "tel://";
      case UserContactType.ERROR:
        return "error";
    }
  }
}

extension ContactHintString on UserContact {
  String get getHintString {
    switch (this.type) {
      case UserContactType.TELEGRAM:
        return "telegram";
      case UserContactType.WHATSAPP:
        return "whatsapp";
      case UserContactType.PHONE:
        return "телефон";
      case UserContactType.ERROR:
        return "ошибка";
    }
  }
}

extension ValidationCallback on UserContact {
  String? Function(String) get checkFunction {
    switch (this.type) {
      case UserContactType.TELEGRAM:
        return (str) {
          if (str.isEmpty) {
            return null;
          }
          if (str.startsWith("@")) {
            return "Пожалуйста, введите логин без @";
          }
          if (str.length < 5) {
            return "Меньше 5 символов";
          }
          if (str.length > 32) {
            return "Больше 33 символов";
          }
          if (!RegExp(r'^[A-Za-z][A-Za-z0-9_]{4,31}$').hasMatch(str)) {
            return "Невалидный логин телеграма";
          }
          return null;
        };
      case UserContactType.WHATSAPP:
        return (str) {
          if (str.isEmpty) {
            return null;
          }
          if (!RegExp(r'^[0-9]*$').hasMatch(str)) {
            return "Формат 7XXXXXXXXXX";
          }
          return null;
        };
      case UserContactType.PHONE:
        return (str) {
          if (str.isEmpty) {
            return null;
          }
          if (!RegExp(r'^[0-9]{11}$').hasMatch(str)) {
            return "Формат 7XXXXXXXXXX";
          }
          return null;
        };
      case UserContactType.ERROR:
        return (str) {
          return "Это тут вообще откуда взялось";
        };
    }
  }
}
