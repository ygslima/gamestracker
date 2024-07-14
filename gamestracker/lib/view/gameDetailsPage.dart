import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamestracker/controller/telaController.dart';
import '../model/game.dart';
import '../model/genre.dart';

// ignore: must_be_immutable
class GameDetailsPage extends StatefulWidget {
  Game _game;
  GameDetailsPage({super.key, required Game game}): _game = game;

  static const String routeName = "/gameDetailsPage";

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  Map<String, dynamic>? actualGameMap;
  String gen ="";
  List<Genre>? ls = [];

  @override
  void initState() async{
    super.initState();
    actualGameMap = widget._game.toMap();
    //ls = await TelaController.getGenresByGame(actualGameMap!["name"]); //TA DANDO MERDA AQUI
    //gen = ls!.first.toMap()["name"];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._game.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("Nome: ${widget._game.name}"),
            Text("Genero: ${TelaController.getGenresByGame(actualGameMap!["name"])}"),
            Text("Data de lancamento: ${gen}"),
          ],
        ),
      ),
    );
  }
}