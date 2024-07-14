import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamestracker/controller/telaController.dart';
import 'package:gamestracker/view/gameDetailsPage.dart';
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
  TextEditingController newGameGenreController = TextEditingController();
  TextEditingController newGameDateController = TextEditingController();
  String newGameNameMessage = "";
  String newGameGenreMessage = "";
  String newGameDateMessage = "";

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

  List<Game?> listaGames = [];

  Future<List<Game?>> gamesList() async{
    return await TelaController.getGames();
  }

  void loadGames() async{
    List<Game?> games = await gamesList();
    setState(() {
      listaGames = games;
    });
  }
  
  void _addGame(){
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState){

          return AlertDialog(
            title: Text("Adicionar Jogo"),
            content: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  controller: newGameNameController,
                  decoration: InputDecoration(labelText: "Nome do Jogo"),
                ),
                Container(child: Text(newGameNameMessage, style: TextStyle(color: Colors.red),), alignment: Alignment.topLeft,),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: newGameDateController,
                  decoration: InputDecoration(labelText: "Ano de lancamento", hintText: "DD/MM/AAAA"),
                  inputFormatters: [maskDateFormatter],
                ),
                Container(child: Text(newGameDateMessage, style: TextStyle(color: Colors.red),), alignment: Alignment.topLeft,),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: newGameGenreController,
                  decoration: InputDecoration(labelText: "Genero"),
                ),
                Container(child: Text(newGameGenreMessage, style: TextStyle(color: Colors.red),), alignment: Alignment.topLeft,),

              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                  newGameDateMessage = "";
                  newGameNameMessage = "";
                  newGameDateController.clear();
                  newGameNameController.clear();
                  newGameGenreController.clear();
                    
                  });
                },
              ),
              TextButton(
                child: Text("Concluir"),
                onPressed: ()  async{
                  bool isValid = true;
                  setState(() {
                    if(newGameNameController.text ==""){
                      print("Nome do jogo invalido");
                        newGameNameMessage = "Nome Invalido";
                      isValid = false;
                    }
                    else{
                      newGameNameMessage = "";
                    }
                    if(newGameDateController.text.length < 10){
                      print("Data invalida");
                      print("LEN : ${newGameDateController.text.length}");
                        newGameDateMessage = "Data invalida";
                      isValid = false;
                    }
                    else{
                      newGameDateMessage = "";
                    }  
                  });
                  if(isValid){
                    print("concluir");
                    int stat = await TelaController.saveNewGame(
                      newGameNameController.text,
                      newGameDateController.text,
                      getUser()!["id"],
                      "ExampleDescription",
                      newGameGenreController.text
                    );
                    print(stat);
                    setState(() {
                      if(stat==0){
                        print("stat: $stat");
                        print(newGameDateController.text);
                        loadGames();
                        Navigator.pop(context);
                        newGameDateMessage = "";
                        newGameNameMessage = "";
                        newGameDateController.clear();
                        newGameNameController.clear();
                        newGameGenreController.clear();
                      }
                      else{
                        print("Jogo ja existente erro");
                        newGameNameMessage = "Jogo ja existente";
                      }  
                    });
                  }
                },
              )
            ],
          );
          }
        );
      },
    );
  }

  void goToGameDetails(Game game){
    print("Indo para detalhes de ${game.name}");
    Navigator.pushNamed(context, GameDetailsPage.routeName, arguments: game);

  }


//-------------------------------------------------------------------------------------------------------
  @override
  void initState(){
    super.initState();
    loadGames();
    print("gerando lista de jogos");
  }

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
              child: ListView.builder(
                itemCount: listaGames.length,
                itemBuilder: (context, index) {
                  final game = listaGames[index];

                  if(true){
                    return ListTile(
                      title: Text(game!.name),
                      subtitle: Text("subtitle qualquer"),
                      onTap: () => goToGameDetails(game),
                    );
                  }
                  
                }
              ),
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