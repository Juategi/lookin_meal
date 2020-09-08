import 'package:flutter/material.dart';

class MenuEntry with ChangeNotifier{
  int  numReviews, pos;
  String name, section, id, restaurant_id, image, description;
  double rating, price;

  set rate(double r){
    rating = r;
    notifyListeners();
  }
  set reviews(int v){
    numReviews = v;
    notifyListeners();
  }

  MenuEntry({this.id, this.restaurant_id, this.numReviews, this.name, this.description, this.section, this.rating, this.price, this.image, this.pos});
}