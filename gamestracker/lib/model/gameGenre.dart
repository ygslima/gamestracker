import 'game.dart';
import 'genre.dart';


//classe associativa de game e genre
class GameGenre{
  Game _game;
  Genre _genre;

  GameGenre(this._game, this._genre);

  Game get game => _game;
  Genre get genre => _genre;
}