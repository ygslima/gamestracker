import 'package:flutter/cupertino.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamestracker/controller/telaController.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../model/game.dart';
import '../model/genre.dart';
import '../model/user.dart';

// ignore: must_be_immutable
class GameDetailsPage extends StatefulWidget {
  Game _game;
  User? _user;
  GameDetailsPage({super.key, required Game game, required User? user}): _game = game, _user = user;

  static const String routeName = "/gameDetailsPage";

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  Map<String, dynamic>? actualGameMap;
  // String gen ="";
  List<Genre> gen = [];
  String genString = "";

  TextEditingController newReviewScoreController = TextEditingController();
  var maskNotaFormatter = MaskTextInputFormatter(mask: "###", filter: { "#": RegExp(r'[0-9]')});
  String newReviewScoreMessage = "";
  TextEditingController newReviewDescriptionController = TextEditingController();
  String newReviewDescriptionMessage = "";

  TextEditingController newGameNameController = TextEditingController();
  TextEditingController newGameGenreController = TextEditingController();
  TextEditingController newGameDateController = TextEditingController();
  TextEditingController newGameDescriptionController = TextEditingController();

  List<String> newGameGenreList = [];
  String newGameNameMessage = "";
  String newGameGenreMessage = "";
  String newGameDateMessage = "";

  var maskDateFormatter = MaskTextInputFormatter(mask: '####-##-##', filter: { "#": RegExp(r'[0-9]') });

  void loadGenreInfo() async{
    gen = await TelaController.getGenresByGame(actualGameMap!["name"]);
    for(Genre genero in gen){
      genString = genString + genero.toMap()["name"] + " ";
    }

    setState(() {
      
    });
  }

  void addReview() async{
    if(widget._user != null){
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState){
              return AlertDialog(
                title: Text("Adicionar Review"),
                content: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: newReviewScoreController,
                      decoration: InputDecoration(labelText: "Nota", hintText: "0 a 100"),
                      inputFormatters: [maskNotaFormatter],
                    ),
                    Text(newReviewScoreMessage, style: TextStyle(color: Colors.red),),
                    
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: newReviewDescriptionController,
                      decoration: InputDecoration(labelText: "Descricao"),
                    ),
                    Text(newReviewDescriptionMessage, style: TextStyle(color: Colors.red),)


                  ],
                ),
                actions: [
                  TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState((){
                        newReviewScoreController.clear();
                        newReviewDescriptionController.clear();
                        newReviewScoreMessage = "";
                        newReviewDescriptionMessage = "";
                      });
                    },
                  ),
                  TextButton(
                    child: Text("Concluir"),
                    onPressed: () {
                      newReviewScoreMessage = "";
                      newReviewDescriptionMessage = "";
                      bool isValid = true;
                      setState((){
                        if(newReviewScoreController.text =="" || double.parse(newReviewScoreController.text) > 100 || double.parse(newReviewScoreController.text) < 0){
                          newReviewScoreMessage = "Nota invalida, por favor insira de 0 a 100";
                          isValid = false;
                        }
                        if(newReviewDescriptionController.text == ""){
                          newReviewDescriptionMessage = "Insira um descricao valida";
                          isValid = false;
                        }
                        if(isValid){
                          final DateTime now = DateTime.now();
                          final String nowStr = DateFormat('yyyy-MM-dd').format(now);
                          print(nowStr);
                          TelaController.addReview(widget._user, widget._game, double.parse(newReviewScoreController.text), newReviewDescriptionController.text, nowStr);
                          Navigator.pop(context);
                          newReviewScoreController.clear();
                          newReviewDescriptionController.clear();
                          newReviewScoreMessage = "";
                          newReviewDescriptionMessage = ""; 
                        }
                      });
                    },
                  )
                ],
              );
            },
          );
        },
      );
    }
    else{
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Voce precisa esta logado para adicionar uma review"),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }

  List<String> multiDropdownMenuEntries = [];
  void getGenresMultiDropdown()async{
    List<Map<String, dynamic>> allGenresRaw = await TelaController.getAllGenres();
    List<String> allGenres = [];
    for(Map<String, dynamic> map in allGenresRaw){
      allGenres.add(map["name"]);
    }
    multiDropdownMenuEntries = allGenres;
  }


  void editGame() async{
    showDialog(
      context: context,
      builder: (context) {
        getGenresMultiDropdown();
        print(multiDropdownMenuEntries);
        newGameNameController.text = widget._game.toMap()["name"];
        newGameDateController.text = widget._game.toMap()["release_date"];
        newGameDescriptionController.text = widget._game.toMap()["description"];
        return StatefulBuilder(
          builder: (context, setState) {
            
            return AlertDialog(
              title: Text("Editar Jogo"),
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
                  decoration: InputDecoration(labelText: "Ano de lancamento", hintText: "AAAA-MM-DD"),
                  inputFormatters: [maskDateFormatter],
                ),
                Container(child: Text(newGameDateMessage, style: TextStyle(color: Colors.red),), alignment: Alignment.topLeft,),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: newGameDescriptionController,
                  decoration: InputDecoration(labelText: "Descricao"),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: newGameGenreController,
                  decoration: InputDecoration(labelText: "Adicionar Genero"),
                ),
                Container(child: Text(newGameGenreMessage, style: TextStyle(color: Colors.red),), alignment: Alignment.topLeft,),

                DropdownSearch<String>.multiSelection(
                  items: multiDropdownMenuEntries,
                  popupProps: PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                  ),
                  onChanged: (List<String> selecionados) {
                    newGameGenreList = selecionados;
                  },

                )
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
                  newGameDescriptionController.clear();
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
                    if(newGameGenreController.text == "" && newGameGenreList.isEmpty){
                      

                    }
                    else{
                      if(newGameGenreController.text != ""){
                        newGameGenreList.add(newGameGenreController.text);
                      }

                    }
                  });
                  print(isValid);
                  if(isValid){
                    print("concluir");
                    int stat = await TelaController.updateGame(
                      widget._game,
                      newGameNameController.text,
                      newGameDateController.text,
                      widget._user,
                      newGameDescriptionController.text,
                      newGameGenreList
                    );
                    print(stat);
                    setState(() {
                      if(stat==0){
                        print("stat: $stat");
                        print(newGameDateController.text);
                        // loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
                        Navigator.pop(context);
                        newGameDateMessage = "";
                        newGameNameMessage = "";
                        newGameDateController.clear();
                        newGameNameController.clear();
                        newGameGenreController.clear();
                        newGameDescriptionController.clear();
                      }
                      else{
                        print("ERRO");
                        newGameNameMessage = "ERRO";
                      }  
                    });
                    setState(() {
                      
                    },);
                  }
                },
              )
              ],

            );
          },
        );
      },
    );
  }



  @override
  void initState(){
    super.initState();
    actualGameMap = widget._game.toMap();
    loadGenreInfo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._game.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              if(widget._user != null && widget._game.toMap()["user_id"] == widget._user!.toMap()["id"]){
                  editGame();

                }
                else{
                  final snackBar2 = SnackBar(
                    duration: Duration(seconds: 5),
                    content: Text("Voce nao tem permissao para editar esse jogo"),

                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                }
              
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("Nome: ${widget._game.name}"),
            Text("Genero: $genString"),
            Text("Data de lancamento: ${widget._game.toMap()["release_date"]}"),
            Text("Descicao"),
            Text(widget._game.toMap()["description"]),

            Divider(),
            ElevatedButton(
              onPressed: () {
                addReview();
              },
              child: Text("Adicionar Review"),
            )
          ],
        ),
      ),
    );
  }
}