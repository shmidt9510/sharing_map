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
