import 'gameGenre.dart';

class Genre{
  String _name;
  List<GameGenre> _gameGenres = [];

  Genre(this._name);

  String get name => _name;
  List<GameGenre> get gameGenres => _gameGenres;

  void addGame(GameGenre gameGenre){
    this._gameGenres.add(gameGenre);
  }

}