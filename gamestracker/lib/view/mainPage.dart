import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamestracker/controller/telaController.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../model/user.dart';
import '../model/game.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  User? _user;
  MainPage({super.key, required User? user}): _user = user;

  static const String routeName = "/mainPage";

  // ignore: unused_variable

  //MainPage.login(this._user);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //User? user = widget._user;

  TextEditingController newGameNameController = TextEditingController();
  Text newGameNameMessage = Text("-");
  TextEditingController newGameGenreController = TextEditingController();
  Text newGameGenreMessage = Text("-");
  TextEditingController newGameDateController = TextEditingController();
  Text newGameDateMessage = Text("-");

  var maskDateFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });


  String _getUsername(){
    if(widget._user != null){
      return widget._user!.toMap()["name"];
    }
    else{
      return "Convidado";
    }
  }

  Map<String, dynamic>? getUser(){
    if(widget._user != null){
      return widget._user!.toMap();
    }
    else{
      return null;
    }
  }

  List<Text> texts = [];

  Future<List<Text>> gamesTitleList() async{
    Future<List<Game?>> futureGames = TelaController.getGames();
    List<Game?> games = await futureGames;
    List<Text> nomes = [];
    for(Game? game in games){
      if(game!=null){
        nomes.add(Text(game.toMap()["name"]));
      }
    }
    texts = nomes;
    return nomes;
    
  }
  





  void _addGame(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Jogo"),
          content: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: newGameNameController,
                decoration: InputDecoration(labelText: "Nome do Jogo"),
              ),
              Container(child: newGameNameMessage, alignment: Alignment.topLeft,),
              TextField(
                keyboardType: TextInputType.number,
                controller: newGameDateController,
                decoration: InputDecoration(labelText: "Ano de lancamento", hintText: "DD/MM/AAAA"),
                inputFormatters: [maskDateFormatter],
              ),
              Container(child: newGameDateMessage, alignment: Alignment.topLeft,),
              TextField(
                keyboardType: TextInputType.text,
                controller: newGameGenreController,
                decoration: InputDecoration(labelText: "Genero"),
              ),
              Container(child: newGameGenreMessage, alignment: Alignment.topLeft,),

            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Concluir"),
              onPressed: ()  async{
                print("concluir");
                Future<int> stat = TelaController.saveNewGame(
                  newGameNameController.text,
                  newGameDateController.text,
                  getUser()!["id"],
                  "ExampleDescription",
                  newGameGenreController.text
                );
                
                print(stat);
                if(stat==0){
                  print(0);
                  print(newGameDateController.text);
                  Navigator.pop(context);

                }
                else{
                  print("asdfa");
                  newGameDateMessage = Text("Data invalida", style: TextStyle(color: Colors.red),);
                }
              },
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo, ${_getUsername()}",
        style: TextStyle(fontSize: 20),),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () => Navigator.pop(context),
          )
        ],
        ),
      body: Center(
        child: Column(
          children: [
            Text(">>AQUI OS CRITERIOS DE BUSCA<<", style: TextStyle(fontSize: 20)),

            Divider(height: 10, thickness: 10,),
            Expanded(
              child: ListView(
                children: texts,
              )
            ),

            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(getUser() != null){
            _addGame();
          }
          else{
            final snackBar = SnackBar(
              content: Text("Voce precisa estar logado para adicionar um jogo!"),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: "Logar",
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    
                  });
                },

              ),

            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}