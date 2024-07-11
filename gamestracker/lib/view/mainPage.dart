import 'package:flutter/material.dart';
import '../model/user.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  User _user;
  MainPage({super.key, required User user}): _user = user;

  static const String routeName = "/mainPage";

  // ignore: unused_variable

  //MainPage.login(this._user);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //User? user = widget._user;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem vindo, ${widget._user.toMap()["name"]}", style: TextStyle(fontSize: 20),), backgroundColor: Colors.blueGrey,),
      body: Center(
        child: Column(
          children: [
            Text(">>AQUI OS CRITERIOS DE BUSCA<<", style: TextStyle(fontSize: 20)),

            Divider(height: 10, thickness: 10,),
            Expanded(
              child: ListView(
                children: [
                  Text("Jogo"),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}