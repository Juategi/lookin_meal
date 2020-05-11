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

  static List<Restaurant> getSubList(List<Restaurant> list){
    List<Restaurant> result = List<Restaurant>();
    for(Restaurant restaurant in list){
      if(ids.contains(restaurant.restaurant_id)){
        result.add(restaurants.firstWhere((r){
          return r.restaurant_id == restaurant.restaurant_id;
        }));
      }
    }
    return result;
  }

}