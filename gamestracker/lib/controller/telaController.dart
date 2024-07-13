import 'dart:io' as io;

import 'package:flutter/material.dart';
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

  static Database? _db;

  static Future<Database?> get db async{
    _db ??= await _initDb();

    print("db init!");
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

          await db.execute(sql1);
          await db.execute(sql2);
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
  
    // Delete the database file
    await io.File(path).delete();

    // Ensure _db is null so that _initDb() will recreate it
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
        print("Login realizado!");
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
    //deleteDatabase();
    User? usr = null;
    Navigator.pushNamed(context, MainPage.routeName, arguments: usr);
    print("Logando como convidado");
    return Text("Logando como Convidado", style: TextStyle(color: Colors.green),);
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
    if(await getGameByName(name) == null){
      print("jogo n existe");
      Game game = Game(name, strDate, userId, description);
      await database!.insert(gameTableName, game.toMap());
      return 0;
    }
    print("jogo existe");
    return 1;
  }




  
}

