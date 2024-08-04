import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:gamestracker/model/gameGenre.dart';
import 'package:gamestracker/model/genre.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../view/MainPage.dart';
import '../model/user.dart';
import '../model/game.dart';
import '../model/review.dart';



class TelaController{

  static final String userTableName = "user";
  static final String gameTableName = "game";
  static final String genreTableName = "genre";
  static final String gameGenreTableName = "game_genre";
  static final String reviewTableName = "review";

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
          CREATE TABLE user(
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
            FOREIGN KEY(user_id) REFERENCES user(id)
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

          String sql5 = """
            CREATE TABLE review(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              game_id INTEGER NOT NULL,
              score REAL NOT NULL,
              description TEXT NOT NULL,
              date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id),
              FOREIGN KEY(game_id) REFERENCES game(id)
            );
          """;

          await db.execute(sql1);
          await db.execute(sql2);
          await db.execute(sql3);
          await db.execute(sql4);
          await db.execute(sql5);
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


  // >>> CONTROLES DE USER <<<

  static Future<User?> getUserById(int id) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "user",
      where: "id = ?",
      whereArgs: [id]
    );
    if(maps.isNotEmpty){
      return User.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  static Future<bool> checkExistingUser(String username) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "user",
      where: "name = ?",
      whereArgs: [username]
    );
    if(maps.isNotEmpty){
      return true;
    }
    else{
      return false;
    }
  }
  

  static Future<User?> getUserByUsername(String username) async{
    var database = await db;
    //erro a partir daqui
    List<Map<String, dynamic>> maps = await database!.query(
      "user",
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
        // print("Senha incorreta");
        return Text("Senha incorreta", style: TextStyle(color: Colors.red),);
      }
    }
    else{
      // print("Login failed. User not found");
      return Text("Usuario nao encontrado", style: TextStyle(color: Colors.red),);
    }
  }



  static Text guestLogin(BuildContext context){
    // deleteDatabase();
    User? usr = null;
    Navigator.pushNamed(context, MainPage.routeName, arguments: usr);
    // print("Logando como convidado");
    return Text("");
  }

  static Future<Text> registerUser(String username, String email, String passw) async{
    var database = await db;
    if(await getUserByUsername(username) == null){
      
      User usr = User(username, email, passw);
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
    // print(maps);
    if(maps.isNotEmpty){
      return Game.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  static Future<Game?> getGameById(int id) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "game",
      where: "id =  ?",
      whereArgs: [id]
    );
    // print(maps);
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



  static Future<int> saveNewGame(String name, String strDate, int userId, String description, List<String> genre) async{
    var database = await db;
    int falha = 0;
    if(await getGameByName(name) == null){
      Game game = Game(name, strDate, userId, description);
      await database!.insert(gameTableName, game.toMap());
      print("Criando novo jogo: ${getGameByName(name)}");
    }
    else{
      falha = 1;
    }
    for(String actualGenre in genre){
      if(await getGenreByName(actualGenre) == null){
        Genre genero = Genre(actualGenre);
        await database!.insert(genreTableName, genero.toMap());
        Game? joj = await getGameByName(name);
        Genre? gen = await getGenreByName(actualGenre);
        GameGenre gameGenre = GameGenre(joj!.toMap()["id"], gen!.toMap()["id"]);
        await database.insert(gameGenreTableName, gameGenre.toMap());
        print("Genre Criado: ${getGenreByName(name)}");
      }
      else{
        Game? joj = await getGameByName(name);
        Genre? gen = await getGenreByName(actualGenre);
        GameGenre gameGenre = GameGenre(joj!.toMap()["id"], gen!.toMap()["id"]);
        await database!.insert(gameGenreTableName, gameGenre.toMap());
        print("adicionando a genre ja existente: ${getGenreByName(name)}");
      }

    }
    
    // print("jogo existe");
    return falha;
  }

  static Future<int> updateGame(Game game, String name, String strDate, User? user, String description, List<String> genre) async{
    var database = await db;
    int falha = 0;
    if(user != null && game.toMap()["user_id"] == user.toMap()["id"]){
      Game gamenew = Game(name, strDate, user.toMap()["id"], description);
      var gameMap = gamenew.toMap();
      gameMap.remove('id');
      await database!.update(
        "game",
        gameMap,
        where: "id = ?",
        whereArgs: [game.toMap()["id"]]
      );
      print("Updating: ${getGameByName(name)}");
    }
    else{
      falha = 1;
    }
    for(String actualGenre in genre){
      if(await getGenreByName(actualGenre) == null){
        Genre genero = Genre(actualGenre);
        await database!.insert(genreTableName, genero.toMap());
        Game? joj = await getGameByName(name);
        Genre? gen = await getGenreByName(actualGenre);
        GameGenre gameGenre = GameGenre(joj!.toMap()["id"], gen!.toMap()["id"]);
        await database.insert(gameGenreTableName, gameGenre.toMap());
        print("Genre Criado: ${getGenreByName(name)}");
      }
      else{
        Game? joj = await getGameByName(name);
        Genre? gen = await getGenreByName(actualGenre);
        GameGenre gameGenre = GameGenre(joj!.toMap()["id"], gen!.toMap()["id"]);
        await database!.insert(gameGenreTableName, gameGenre.toMap());
        print("adicionando a genre ja existente: ${getGenreByName(name)}");
      }

    }
    
    // print("jogo existe");
    return falha;
  }


  static Future<List<Game?>> searchGamesByName(String name) async{
    var database = await db;
    String searchParameter = "%$name%";
    List<Map<String, dynamic>> maps = await database!.query(
      "game",
      where: "name LIKE ?",
      whereArgs: [searchParameter]
    );
    print("Resultado da busca com nome $name ==>> $maps");
    List<Game?> list = [];
    if(maps.isNotEmpty){
      for(Map<String, dynamic> map in maps){
        list.add(Game.fromMap(map));
      }
    }
    return list;

  }

  static Future<double?> getGameScoreById(int id) async{
    var database = await db;
    double? soma = -1;
    List<Map<String, dynamic>> maps = await database!.query(
      "review",
      where: "game_id = ?",
      whereArgs: [id]
    );
    if(maps.isNotEmpty){
      soma = 0;
      for(Map<String, dynamic> map in maps){
        soma = soma!+ (map["score"]);
      }
      soma = soma!/(maps.length);
    }
    else{
      soma = null;
    }
    return soma;
  }


  static Future<List<Game?>> searchGamesByParameters(String? name, int? genre_id, String? release_year, double? minRate, User? user) async{
    var database = await db;
    String sql = "SELECT game.id, game.name, game.release_date, coalesce(avg(score), -1) as media from game left join review on game.id = review.game_id inner join game_genre on game_genre.game_id = game.id ";
    int num_where = 0;
    List<Game?> list = [];
    if(user != null){
    int searchUserId = user.toMap()["id"];
    if (release_year != null || genre_id != null || minRate != null || name != null){
      sql = sql + "Where ";
      if (name != null){
        sql = sql + "name LIKE '%$name%'";
        num_where++;
      }
      if (release_year != null){
        if (num_where > 0) sql = sql + " AND "; 
        sql = sql + "strftime('%Y', release_date) >= $release_year";
        num_where++;
      }
      if (genre_id != null) {
        if (num_where > 0) sql = sql + " AND ";
        sql = sql + "game_genre.genre_id = $genre_id";
        num_where++;
      }
      if (minRate != null){
        if (num_where > 0) sql = sql + " AND ";
        sql = sql + "(select avg(score) from review r2 where r2.game_id = game.id ) > $minRate";
        num_where++;
      }
    }
    else sql = sql + "Where game.user_id = $searchUserId";
    }
    sql = sql + " group by review.game_id order by game.name; ";
    print(sql);
    List<Map<String, dynamic>> results = await database!.rawQuery(sql);
    if(results.isNotEmpty){
      print("Parametros de busca: $name, $genre_id, $release_year, $minRate \n //Resultados da busca: $results");
      for(Map<String, dynamic> map in results){
        Game? jogo = await getGameById(map["id"]); 
        list.add(jogo);
    }
    }
    return list;

  }


  





  // >>>CONTROLES DE GENRE <<<

  static Future<Genre?> getGenreByName(String name) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "genre",
      where: "name = ?",
      whereArgs: [name]
    );
    // print(maps);
    if(maps.isNotEmpty){
      return Genre.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  static Future<Genre?> getGenreById(int id) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "genre",
      where: "id = ?",
      whereArgs: [id]
    );
    if(maps.isNotEmpty){
      return Genre.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllGenres()async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "genre"
    );
    if(maps.isNotEmpty){
      return maps;
    }
    else return maps;
  }

  // >>> CONTROLES DE GAMEGENRE <<<


  static Future<List<Map<String, dynamic>>> getAllGameGenres()async{
    var database = await db;
    return await database!.query("game_genre");
  }

  static Future<List<Game>?> getGamesByGenre(String genre) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "game_genre",
      where: "genre_id = ?",
      whereArgs: [genre]
    );
    // print(maps);
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

  static Future<List<Genre>> getGenresByGame(String name) async{
    var database = await db;
    Game? game = await getGameByName(name);
    List<Genre> lista = [];
    print("game: $game");
    List<Map<String, dynamic>> maps = await database!.query(
      "game_genre",
      where: "game_id = ?",
      whereArgs: [game!.toMap()["id"]]
    );
    if(maps.isNotEmpty){
      for(Map<String, dynamic> map in maps){
        Genre? gen = await getGenreById(map["genre_id"]);
        lista.add(gen!);
        print("add map: $map");
      }
      print("Jogo $name, // Genres: $maps");
      return lista;
    }
    return lista;
  }


  // >>> CONTROLES DE REVIEW <<<

  static Future<List<Review?>> getReviews() async{
    var database = await db;
    List<Review?> reviews = [];
    List<Map<String, dynamic>> maps = await database!.query("review");
    if(maps.isNotEmpty){
      for(Map<String, dynamic> map in maps){
        reviews.add(Review.fromMap(map));
        print("review: ${map["date"]}");
      }
    }
    return reviews;

  }

  static Future<int> addReview(User? user, Game game, double score, String description, String date) async{
    if(user == null){
      print("usuario nao logado");
      return 1;
    }
    else{
      print("usuario logado, adicionando rev");
      var database = await db;
      Review review = Review(user.toMap()["id"], game.toMap()["id"], score, description, date);
      await database!.insert(reviewTableName, review.toMap());
      print(review);

    }
    return 0;
  }

  static Future<Review?> getReviewById(int id) async{
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "review",
      where: "id = ?",
      whereArgs: [id]
    );
    if(maps.isNotEmpty){
      return Review.fromMap(maps.first);
    }
    else{
      return null;
    }
  }



  static Future<List<Review>?> getReviewsByGame(String name) async{
    var database = await db;
    Game? game = await getGameByName(name);
    List<Map<String, dynamic>> maps = await database!.query(
      "review",
      where: "game_id = ?",
      whereArgs: [game!.toMap()["id"]]
    );
    if(maps.isNotEmpty){
      List<Review> list = [];
      for(Map<String, dynamic> map in maps){
        Review? rev = await getReviewById(map["id"]);
        list.add(rev!);
      }
      return list;
    }
    else{
      return null;
    }
  }

  static Future<List<Review?>> getRecentReviews(int days) async{
    final DateTime now = DateTime.now();
    final DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
    final String nowStr = DateFormat('yyyy-MM-dd').format(now);
    final String sevenDaysAgoStr = DateFormat('yyyy-MM-dd').format(sevenDaysAgo);
    var database = await db;
    List<Map<String, dynamic>> maps = await database!.query(
      "review",
      where: "date BETWEEN ? AND ?",
      whereArgs: [sevenDaysAgoStr, nowStr],
      orderBy: "date DESC"
    );
    print(maps);
    List<Review> list = [];
    if(maps.isNotEmpty){
      for(Map<String, dynamic> map in maps){
        Review? rev = await getReviewById(map["id"]);
        list.add(rev!);
      }
    }
    return list;
  }

  
}

