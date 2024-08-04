import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gamestracker/controller/telaController.dart';
import 'package:gamestracker/view/gameDetailsPage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../model/user.dart';
import '../model/game.dart';
import 'recentReviewsPage.dart';
import '../model/genre.dart';
// import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';



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
  List<String> newGenres = [];
  TextEditingController newGameNameController = TextEditingController();
  TextEditingController newGameGenreController = TextEditingController();
  TextEditingController newGameDateController = TextEditingController();
  TextEditingController newGameDescriptionController = TextEditingController();
  List<String> newGameGenreList = [];
  String newGameNameMessage = "";
  String newGameGenreMessage = "";
  String newGameDateMessage = "";
  //Controles de busca
  TextEditingController buscaJogosNameController = TextEditingController();
  TextEditingController buscaJogosMinScoreController = TextEditingController();
  TextEditingController buscaJogosAnoController = TextEditingController();
  TextEditingController buscaJogosGeneroController = TextEditingController();
  //Parametros de busca:
  double? searchParameterMin = null;
  String? searchParameterName = null;
  String? searchParameterYear = null;
  String? searchParameterGenre = null;

  List<Map<String, dynamic>> itemList = [];

  var maskDateFormatter = MaskTextInputFormatter(mask: '####-##-##', filter: { "#": RegExp(r'[0-9]') });
  var maskRateSearchFormatter = MaskTextInputFormatter(mask: '###', filter: { "#": RegExp(r'[0-9]') });
  var maskYearSearchFormatter = MaskTextInputFormatter(mask: '####', filter: { "#": RegExp(r'[0-9]') });


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

  List<Map<String, dynamic>> listaGames = [];

  void loadGamesParameter(String? name, String? genre, String? release_year, double? min) async{
    listaGames.clear();
    print("LoadGamesParameter com nome $name, genero $genre, ano $release_year, minimo $min");
    int? gen_id;
    if(genre != null){
      Genre? gen =  await TelaController.getGenreByName(genre);
      gen_id = gen!.toMap()["id"];
    }
    else gen_id = null;

    List<Game?> games = await TelaController.searchGamesByParameters(name, gen_id, release_year, min, widget._user);
    for(Game? game in games){
      double? nota = await TelaController.getGameScoreById(game!.toMap()["id"]);
      listaGames.add({
        "game": game,
        "nota": nota
      });

    }
    setState(() {
      
    }); 

  }

  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  void getGenresDropdown()async{
    List<Map<String, dynamic>> allGenresRaw = await TelaController.getAllGenres();
    List<String> allGenres = [];
    for(Map<String, dynamic> map in allGenresRaw){
      allGenres.add(map["name"]);
    }
    print(allGenres);
    dropdownMenuEntries = allGenres.map((String item) {
      return DropdownMenuEntry<String>(
        value: item,
        label: (item),
      );
    }).toList();
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

  void _searchFilters(){
    showDialog(
      context: context,
      builder: (context) {
        getGenresDropdown();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Filtros"),
              content: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: buscaJogosAnoController,
                    decoration: InputDecoration(labelText: "Ano"),
                    inputFormatters: [maskYearSearchFormatter],

                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: buscaJogosMinScoreController,
                    decoration: InputDecoration(labelText: "Min. Score"),
                    inputFormatters: [maskRateSearchFormatter],

                  ),

                  Divider(height: 10, thickness: 10, color: Colors.transparent,),
                  DropdownMenu(
                    // controller: buscaJogosGeneroController,
                    onSelected: (value) {
                      searchParameterGenre = value;
                    },
                    dropdownMenuEntries: dropdownMenuEntries,
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Limpar"),
                  onPressed: () {
                    buscaJogosAnoController.clear();
                    buscaJogosGeneroController.clear();
                    buscaJogosMinScoreController.clear();
                    searchParameterGenre = null;
                    searchParameterMin = null;
                    searchParameterYear = null;
                    loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
                    Navigator.pop(context);
                    setState(() {
                      
                    });
                  },
                ),
                TextButton(
                  child: Text("Aplicar"),
                  onPressed: () {
                    if(buscaJogosAnoController.text==""){
                      searchParameterYear = null;
                    }
                    else{
                      searchParameterYear = buscaJogosAnoController.text;
                      print(buscaJogosAnoController.text);
                    }
                    if(buscaJogosMinScoreController.text ==""){
                      searchParameterMin = null;
                    }
                    else{
                      searchParameterMin = double.parse(buscaJogosMinScoreController.text);
                    }
                    loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
                    Navigator.pop(context);
                    setState((){
                      
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
  
  void _addGame(){
    showDialog(
      context: context,
      builder: (context) {
        getGenresMultiDropdown();
        print(multiDropdownMenuEntries);
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
                  decoration: InputDecoration(labelText: "Genero"),
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
                      isValid = false;

                    }
                    else{
                      if(newGameGenreController.text != ""){
                        newGameGenreList.add(newGameGenreController.text);
                      }

                    }
                  });
                  if(isValid){
                    print("concluir");
                    int stat = await TelaController.saveNewGame(
                      newGameNameController.text,
                      newGameDateController.text,
                      getUser()!["id"],
                      newGameDescriptionController.text,
                      newGameGenreList
                    );
                    print(stat);
                    setState(() {
                      if(stat==0){
                        print("stat: $stat");
                        print(newGameDateController.text);
                        loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
                        Navigator.pop(context);
                        newGameDateMessage = "";
                        newGameNameMessage = "";
                        newGameDateController.clear();
                        newGameNameController.clear();
                        newGameGenreController.clear();
                        newGameDescriptionController.clear();
                      }
                      else{
                        print("Jogo ja existente erro");
                        newGameNameMessage = "Jogo ja existente";
                      }  
                    });
                    setState(() {
                      
                    },);
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
    Map<String, dynamic> mapa = {
      "game": game,
      "user": widget._user
    };
    Navigator.pushNamed(context, GameDetailsPage.routeName, arguments: mapa).then((_)=> setState(() {}));

  }

  List<Map<String, dynamic>> allGameGenres = [];
  void getAllGameGenres()async{
    allGameGenres = await TelaController.getAllGameGenres();
    print("Game genres: $allGameGenres");
  }


//-------------------------------------------------------------------------------------------------------
  @override
  void initState(){
    super.initState();
    // print(widget._user!.toMap());
    buscaJogosNameController.text = "";
    searchParameterName = null;
    loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
    print("gerando lista de jogos");
    getGenresDropdown();
    getAllGameGenres();
    // print("GAME GENRES: $allGameGenres");
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
            icon: Icon(Icons.chat_rounded),
            onPressed:() => Navigator.pushNamed(context, RecentReviewsPage.routeName)
          ),
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        ),
      body: Center(
        child: Column(
          children: [
            Text("BUSCAR JOGOS", style: TextStyle(fontSize: 20)),

            TextField(
              keyboardType: TextInputType.text,
              controller: buscaJogosNameController,
              decoration: InputDecoration(labelText: "Buscar"),
              onChanged: (value) {
                print("VALOR : ${buscaJogosNameController.text}");
                if(buscaJogosNameController.text == ""){
                  searchParameterName = null;
                }
                else{
                  searchParameterName = buscaJogosNameController.text;
                }
                loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
                
              },
            ),
            /*
            TextField(
              keyboardType: TextInputType.text,
              controller: buscaJogosMinScoreController,
              decoration: InputDecoration(labelText: "Min. Score"),
              inputFormatters: [maskRateSearchFormatter],
              onChanged: (value) {
                setState(() {
                  if(buscaJogosMinScoreController.text==""){
                    searchParameterMin = null;
                  }
                  else{
                    searchParameterMin = double.parse(buscaJogosMinScoreController.text);
                  }
                  loadGamesParameter(searchParameterName, searchParameterGenre, searchParameterYear, searchParameterMin);
                });
              },
            ),
            */
            Text("Filros"),
            IconButton(
              icon: Icon(Icons.filter_list_sharp),
              onPressed: () {
                _searchFilters();
                setState(() {
                  
                });
              },
            ),
            

            Divider(height: 10, thickness: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: listaGames.length,
                itemBuilder: (context, index) {
                  final game = listaGames[index];

                  if(game["nota"]!=null){
                    return ListTile(
                      title: Text(game["game"].toMap()["name"]),
                      subtitle: Text("Score: ${game["nota"]}"),
                      onTap: () => goToGameDetails(game["game"]),
                    );
                  }
                  else{
                    return ListTile(
                      title: Text(game["game"].toMap()["name"]),
                      subtitle: Text("Sem avaliacoes ate agora"),
                      onTap: () => goToGameDetails(game["game"]),
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