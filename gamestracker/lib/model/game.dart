class Game{
  int? _id;
  int _userId = 0;
  String _name = "";
  String _date = "";
  String _description = "";


  Game(this._name, this._date, this._userId, this._description);

  Game.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._userId = map["user_id"];
    this._name = map["name"];
    this._description = map["description"];
    this._date = map["release_date"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id": this._id,
      "user_id": this._userId,
      "name": this._name,
      "description": this._description,
      "release_date": this._date
    };
    return map;
  }

  String get name => _name;
}