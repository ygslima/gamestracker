import 'game.dart';
import 'user.dart';

class Review{
  Game _game;
  User _autor;

  Review(this._autor, this._game);

  Game getGame() => _game;
  User getAutor() => _autor;
}