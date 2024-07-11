import 'review.dart';

class User{
  int? _id;
  String? _name;
  String? _email;
  String? _password;
  List<Review> _reviews = [];


  //metodos
  User(this._name, this._email, this._password);

  User.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._name = map["name"];
    this._email = map["email"];
    this._password = map["password"];
    //this._reviews = map["reviews"];
  }

  List<Review> getReviews() => _reviews;
  int? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this._name,
      "email": this._email,
      "password": this._password,
      //"reviews": this._reviews
    };
    if(this._id != null){
      map["id"] = this._id;
    }

    return map;
  }


}