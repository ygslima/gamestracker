import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:gamestracker/model/gameGenre.dart';
import 'package:gamestracker/model/genre.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../view/MainPage.dart';
import '../model/user.dart';
import '../model/game.dart';



class TelaController{

  static final String userTableName = "users";
  static final String gameTableName = "game";
  static final String genreTableName = "genre";
  static final String gameGenreTableName = "game_genre";

  static Database? _db;

  static Future<Database?> get db async{
    _db ??= await _initDb();

    //print("db init!");
    return _db;
  }

  static Future<Database?> _initDb() async{
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocumentsDir.path, "databases", "app.db");
    print("Database path: $path");

    Database? db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async{
          String sql1 = """
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL
          );
          """;

          String sql2 = """
            CREATE TABLE game(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name VARCHAR NOT NULL UNIQUE,
            description TEXT NOT NULL,
            release_date VARCHAR NOT NULL,
            FOREIGN KEY(user_id) REFERENCES users(id)
          );
          """;
          
          String sql3 = """
            CREATE TABLE genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );
            """;

          String sql4 = """
            CREATE TABLE game_genre(
              game_id INTEGER NOT NULL,
              genre_id INTEGER NOT NULL,
              FOREIGN KEY(game_id) REFERENCES game(id),
              FOREIGN KEY(genre_id) REFERENCES genre(id)
            );
          """;

          await db.execute(sql1);
          await db.execute(sql2);
          await db.execute(sql3);
          await db.execute(sql4);
        }
      )
    );

    return db;
  }

  Future<int> addUser(User user) async{
    var database = await db;
    int id = await database!.insert(userTableName, user.toMap());

    return id;
  }

  getUsers() async{
    var database = await db;
    String sql = "SELECT * FROM $userTableName";

    List users = await database!.rawQuery(sql);
    return users;
  }

  static Future<User?> getUserByUsername(String username) async{
    var database = await db;
    //erro a partir daqui
    List<Map<String, dynamic>> maps = await database!.query(
      "users",
      where: "name =  ?",
      whereArgs: [username]
    );
    if(maps.isNotEmpty){
      return User.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  static Future<void> deleteDatabase() async {
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocumentsDir.path, "databases", "app.db");
    await io.File(path).delete();
    _db = null;
  }





  // >>> CONTROLES DE LOGIN <<<

  static Future<Text> loginAuth(BuildContext context, String username, String passw) async{
    User? usr = await getUserByUsername(username);
    //COLOCAR CONDICAO DE LOGIN AQUI
    if(usr != null){
      Map<String, dynamic> map = usr.toMap();
      //aqui ele associa a o username ao objeto da classe usuario, que e passada como parametro
      if(map["password"]==passw){
        print("Login realizado! Usuario: $username");
        Navigator.pushNamed(context, MainPage.routeName, arguments: usr);
        return Text("", style: TextStyle(color: Colors.green),);
      }
      else{
        print("Senha incorreta");
        return Text("Senha incorreta", style: TextStyle(color: Colors.red),);
      }
    }
    else{
      print("Login failed. User not found");
      return Text("Usuario nao encontrado", style: TextStyle(color: Colors.red),);
    }
  }

  static Text guestLogin(BuildContext context){
    deleteDatabase();
    User? usr = null;
    Navigator.pushNamed(context, MainPage.routeName, arguments: usr);
    print("Logando como convidado");
    return Text("");
  }

  static Future<Text> registerUser(String username, String passw) async{
    var database = await db;
    if(await getUserByUsername(username) == null){
      
      User usr = User(username, "dafaultmail@gamestracker.com", passw);
      await database!.insert(userTableName, usr.toMap());
      return Text("");
    }
    else{
      return Text("Usuario ja existente", style: TextStyle(color: Colors.red),);
    }

  }


  // >>> CONTROLES DE GAMES <<<

  static Future<Game?> getGameByName(String name) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "game",
      where: "name =  ?",
      whereArgs: [name]
    );
    print(maps);
    if(maps.isNotEmpty){
      return Game.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  static Future<List<Game?>> getGames() async{
    var database = await db;
    List<Game?> games = [];
    List<Map<String, dynamic>> maps = await database!.query("game");
    if(maps.isNotEmpty){
      for(Map<String, dynamic> game in maps){
        games.add(Game.fromMap(game));
      }
    }
    return games;

  }



  static Future<int> saveNewGame(String name, String strDate, int userId, String description, String genre) async{
    var database = await db;
    int falha = 0;
    if(await getGameByName(name) == null){
      print("criando novo jogo");
      Game game = Game(name, strDate, userId, description);
      await database!.insert(gameTableName, game.toMap());
    }
    else{
      falha = 1;
    }
    if(await getGenreByName(genre) == null){
      print("criando novo genre");
      Genre genero = Genre(genre);
      await database!.insert(genreTableName, genero.toMap());
      Game? joj = await getGameByName(name);
      Genre? gen = await getGenreByName(genre);
      GameGenre gameGenre = GameGenre(joj!.toMap()["id"], gen!.toMap()["id"]);
      await database.insert(gameGenreTableName, gameGenre.toMap());
    }
    else{
      falha = 2;
    }
    
    print("jogo existe");
    return falha;
  }


  // >>>CONTROLES DE GENRE <<<

  static Future<Genre?> getGenreByName(String name) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "genre",
      where: "name = ?",
      whereArgs: [name]
    );
    print(maps);
    if(maps.isNotEmpty){
      return Genre.fromMap(maps.first);
    }
    else{
      return null;
    }
  }



  // >>> CONTROLES DE GAMEGENRE <<<

  static Future<List<Game>?> getGamesByGenre(String genre) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "game_genre",
      where: "genre_id = ?",
      whereArgs: [genre]
    );
    print(maps);
    if(maps.isNotEmpty){
      List<Game> lista = [];
      for(Map<String, dynamic> map in maps){
        lista.add(Game.fromMap(map));
      }
      return lista;
    }
    else{
      return null;
    }
  }

  static Future<List<Genre>?> getGenresByGame(String game) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "game_genre",
      where: "game_id = ?",
      whereArgs: [game]
    );
    print(maps);
    if(maps.isNotEmpty){
      List<Genre> lista = [];
      for(Map<String, dynamic> map in maps){
        lista.add(Genre.fromMap(map));
      }
      return lista;
    }
    else{
      return null;
    }
  }

  
}

