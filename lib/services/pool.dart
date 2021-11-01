import 'package:lookinmeal/models/restaurant.dart';

class Pool{
  static List<Restaurant> restaurants = [];
  //static List<String> ids = List<String>();

  static Restaurant getRestaurant(String id){
    for(Restaurant restaurant in restaurants) {
      if (restaurant.restaurant_id == id)
        return restaurant;
    }
    return null;
  }

  static void addRestaurant(Restaurant restaurant){
    restaurants.add(restaurant);
  }

  /*static void addRestaurants(List<Restaurant> list){
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
   */

}