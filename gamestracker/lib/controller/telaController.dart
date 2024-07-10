import 'package:flutter/material.dart';
import '../view/MainPage.dart';
import '../model/user.dart';

class TelaController{


  static void loginAuth(BuildContext context, String username, String passw){
    //COLOCAR CONDICAO DE LOGIN AQUI
    if(true){
      //aqui ele associa a o username ao objeto da classe usuario, que e passada como parametro
      User user = User(username);
      print("Login realizado!");
      Navigator.pushNamed(context, MainPage.routeName, arguments: user);
    }
  }
}