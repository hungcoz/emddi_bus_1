import 'dart:convert';

import 'package:emddi_bus/constants/constant.dart';
import 'package:http/http.dart' as http;

String urlLogin = url + "/login";
String username = "0987654321";
String password = "12345678";

class Login {
  Login({
    this.code,
    this.message,
    this.token,
  });

  int code;
  String message;
  String token;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    code: json["code"],
    message: json["message"],
    token: json["data"]["token"],
  );
}

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

Future<void> getToken() async {
  final response = await http
      .post(urlLogin, body: {"phone_number": username, "password": password});
  if (response.statusCode == 200) {
    var login = loginFromJson(response.body);
    if (login.code == 0) {
      token = login.token;
    } else
      throw Exception(login.message);
  } else
    throw Exception("Không thể lấy token");
}
