import 'package:flutter/material.dart';
import 'view/loginPage.dart';
import 'view/MainPage.dart';
import 'model/user.dart';
void main(){
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {

    },
    onGenerateRoute: (settings) {
      if(settings.name == MainPage.routeName){
        final args = settings.arguments as User;
        return MaterialPageRoute(builder: (context) => MainPage(user: args));
      }
      return null;
    },

    title: ("Games Tracker"),
    debugShowCheckedModeBanner: false,
    home: LoginPage(),

  ));
}