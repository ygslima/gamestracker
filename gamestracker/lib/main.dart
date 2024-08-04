import 'package:flutter/material.dart';
// import 'package:path/path.dart';
import 'view/loginPage.dart';
import 'view/MainPage.dart';
import 'model/user.dart';
import 'view/gameDetailsPage.dart';
import 'model/game.dart';
import 'view/recentReviewsPage.dart';
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
        final args = settings.arguments as Map<String, dynamic>;
        final gam = args["game"] as Game;
        final usr = args["user"] as User?;
        return MaterialPageRoute(builder: (context) => GameDetailsPage(game: gam, user: usr,));
      }
      if(settings.name == RecentReviewsPage.routeName){
        return MaterialPageRoute(builder: (context) => RecentReviewsPage());
      }
      return null;
    },

    title: ("Games Tracker"),
    debugShowCheckedModeBanner: false,
    home: LoginPage(),

  ));
}