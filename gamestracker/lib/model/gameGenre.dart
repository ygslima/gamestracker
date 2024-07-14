//classe associativa de game e genre
class GameGenre{
  int? _gameId;
  int? _genreId;

  GameGenre(this._gameId, this._genreId);

  GameGenre.fromMap(Map<String, dynamic> map){
    this._gameId = map["game_id"];
    this._genreId = map["genre_id"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "game_id": this._gameId,
      "genre_id": this._genreId
    };
    return map;
  }

}