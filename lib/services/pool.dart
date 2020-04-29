import 'package:lookinmeal/models/restaurant.dart';

class Pool{
  static List<Restaurant> restaurants = List<Restaurant>();
  static List<String> ids = List<String>();

  static void addRestaurants(List<Restaurant> list){
    for(Restaurant r in list){
      if(!ids.contains(r.restaurant_id)){
        restaurants.add(r);
        ids.add(r.restaurant_id);
      }
    }
  }

}