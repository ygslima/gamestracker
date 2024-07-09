import 'package:flutter/material.dart';
import 'home.dart';
import 'loginPage.dart';
void main(){
  runApp(MaterialApp(
    title: ("Games Tracker"),
    debugShowCheckedModeBanner: false,
    home: LoginPage(),

  ));
}