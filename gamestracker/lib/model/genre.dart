class Genre{
  int? _id;
  String _name = "";
  

  Genre(this._name);

  Genre.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id": this._id,
      "name": this._name
    };
    return map;
  }

  String get name => _name;

}