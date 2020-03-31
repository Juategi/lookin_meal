import 'package:http/http.dart' as http;
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';

class DBServiceN{

  //URL: https://lookinmeal-dcf41.firebaseapp.com
  String uid;

  Future updateUserData(String email, String name, String picture, String service ) async {

  }

  Future updateUserImage(String picture,String uid) async {

  }


  Future updateUserFavorites(String id) async{

  }

  Future updateRestaurantData(String taId, String name, String phone, String website, String webUrl, String address, String email, String city, String country, double latitude,
      double longitude, double rating, int numberViews, List<String> images, List<String> types, Map<String,List<int>> schedule ) async{

  }



  Future<List<Restaurant>> get allrestaurantdata async{

  }

  Future<List<Restaurant>> geFavorites(List<String> ids) async{

  }


  Stream<User> get userdata{

  }

}