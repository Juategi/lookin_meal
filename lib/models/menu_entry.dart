import 'package:flutter/material.dart';

class MenuEntry with ChangeNotifier{
  int  numReviews, pos;
  String name, section, id, restaurant_id, image, description;
  bool hide;
  double rating, price;
  List<String> allergens;

  set rate(double r){
    rating = r;
    notifyListeners();
  }
  set reviews(int v){
    numReviews = v;
    notifyListeners();
  }

  MenuEntry({this.id, this.restaurant_id, this.numReviews, this.name, this.description, this.section, this.rating, this.price, this.image, this.pos, this.allergens, this.hide});
}