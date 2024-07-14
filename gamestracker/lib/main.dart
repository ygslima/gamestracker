import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'view/loginPage.dart';
import 'view/MainPage.dart';
import 'model/user.dart';
import 'view/gameDetailsPage.dart';
import 'model/game.dart';
void main() async{
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {

    },
    onGenerateRoute: (settings) {
      if(settings.name == MainPage.routeName){
        final args = settings.arguments as User?;
        return MaterialPageRoute(builder: (context) => MainPage(user: args));
      }
      if(settings.name == GameDetailsPage.routeName){
        final args = settings.arguments as Game;
        return MaterialPageRoute(builder: (context) => GameDetailsPage(game: args));
      }
      return null;
    },

    title: ("Games Tracker"),
    debugShowCheckedModeBanner: false,
    home: LoginPage(),

  ));
}