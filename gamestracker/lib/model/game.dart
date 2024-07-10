import 'package:gamestracker/model/gameGenre.dart';

class Game{
  String _name;
  List<GameGenre> _gameGenres = [];


  Game(this._name);

  String get name => _name;
  List<GameGenre> get gameGenres => _gameGenres;

  void addGenre(GameGenre gameGenre){
    this._gameGenres.add(gameGenre);
  }

}