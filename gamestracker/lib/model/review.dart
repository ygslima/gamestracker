class Review{
  int? _id;
  int? _userId;
  int? _gameId;
  double? _score;
  String? _description;
  String? _date;

  Review(this._userId, this._gameId, this._score, this._description, this._date);

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id": this._id,
      "user_id": this._userId,
      "game_id": this._gameId,
      "score": this._score,
      "description": this._description,
      "date": this._date
    };
    return map;
  }

  Review.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._userId = map["user_id"];
    this._gameId = map["game_id"];
    this._score = map["score"];
    this._description = map["description"];
    this._date = map["date"];
  }

}