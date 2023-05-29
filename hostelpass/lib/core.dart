import 'package:flutter/material.dart';
import 'package:hostelpass/control_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

const serverURL = '192.168.20.7';
const clientDomain = 'localhost:3000';
const clientURL = "$clientDomain/security?gatePass=";

Future<String?> getToken() async {
  final token = await SharedPreferences.getInstance();
  final savedToken = token.getString('jwt');
  return savedToken;
}

Future<void> logOut(context) async {
  final token = await SharedPreferences.getInstance();
  token.clear();
  ControlApp.currentIndexValueNotifier = ValueNotifier(0);
  Navigator.of(context).pushNamedAndRemoveUntil(
    'SCREEN_LOGIN',
    (Route<dynamic> route) => false,
  );
}
