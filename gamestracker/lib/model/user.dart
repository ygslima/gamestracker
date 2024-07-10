import 'review.dart';

class User{
  String _name;
  List<Review> _reviews = [];


  //metodos
  User(this._name);

  List<Review> getReviews() => _reviews;
  String get name => _name;
}