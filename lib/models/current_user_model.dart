import 'package:flutter/cupertino.dart';

class CurrentUserModel {
  String? id;
  String ?name;
  String ?phone;
  String ?email;
  String ?pass;
  String ?token;
  String ?hasOrderId;
  String ?imageStr;
  String ?imageUrl;
  bool? hasOrder;
  int? ordersNumber;

  CurrentUserModel({
    this.id = 'NULL',
    this.name = 'NULL',
    this.phone = 'NULL',
    this.email = 'NULL',
    this.pass = 'NULL',
    this.token = 'NULL',
    this.hasOrderId = 'NULL',
    this.imageStr = 'NULL',
    this.imageUrl = 'NULL',
    this.hasOrder = false,
    this.ordersNumber = 0,
  });

  CurrentUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    pass = json['pass'];
    token = json['token'];
    hasOrderId = json['hasOrderId'];
    hasOrder = json['hasOrder'];
    ordersNumber = json['ordersNumber'];
    imageStr = json['imageStr'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'pass': pass,
    'token': token,
    'hasOrderId': hasOrderId,
    'hasOrder': hasOrder,
    'ordersNumber': ordersNumber,
    'imageStr': imageStr,
    'imageUrl': imageUrl,
  };
}
