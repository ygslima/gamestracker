import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../view/MainPage.dart';
import '../model/user.dart';



class TelaController{

  static final String userTableName = "users";

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
          String sql = """
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL
          );
          """;

          await db.execute(sql);
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



  static Future<String> loginAuth(BuildContext context, String username, String passw) async{
    User? usr = await getUserByUsername(username);
    //COLOCAR CONDICAO DE LOGIN AQUI
    if(usr != null){
      Map<String, dynamic> map = usr.toMap();
      //aqui ele associa a o username ao objeto da classe usuario, que e passada como parametro
      if(map["password"]==passw){
        print("Login realizado!");
        Navigator.pushNamed(context, MainPage.routeName, arguments: usr);
        return "Sucesso";
      }
      else{
        print("Senha incorreta");
        return "Senha incorreta";
      }
    }
    else{
      print("Login failed. User not found");
      return "Usuario nao encontrado";
    }
  }

  static Future<String> registerUser(String username, String passw) async{
    var database = await db;
    if(await getUserByUsername(username) == null){
      
      User usr = User(username, "dafaultmail@gamestracker.com", passw);
      await database!.insert(userTableName, usr.toMap());
      return "";
    }
    else{
      return "Usuario ja existente";
    }

  }


  
}

