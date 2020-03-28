import 'package:postgres/postgres.dart';

class DBServiceN{

  final connection = new PostgreSQLConnection("104.155.57.239", 5432, "lookinmeal", username: "postgres", password: "qHeNfB1d5jNOrf8o", useSSL: true);
  Future updateRestaurantData(String id, String name, String phone, String website, String webUrl, String address, String email, String city, String country, double latitude,
      double longitude, double rating, int numberViews, List<String> images, List<String> types, Map<String,List<int>> schedule )async{
    List<String> sections = ["Entrantes", "Carnes", "Postres"];
    String query = "insert into restaurant (ta_id,name,address,city,country,email,phone,website,types,images,schedule,rating,latitude,longitude,numRevta,sections,currency) values "
        "(@id,@name,@address,@city,@country,@email,@phone,@website,@types,@images,@schedule,@rating,@latitude,@longitude,@numberViews,@sections,@currency);";
    print(query);
    dynamic result = await connection.open();
    print(result);
    result = await connection.query(query,substitutionValues:{
      "@id": id,
      "@name": name,
      "@address": address,
      "@city": city,
      "@countr": country,
      "@email": email,
      "@phone": phone,
      "@website": website,
      "@types": types,
      "@schedule": schedule,
      "@rating": rating,
      "@latitude": latitude,
      "@longitude": longitude,
      "@numberViews": numberViews,
      "@sections": sections,
      "@currency": "€"
    });
    print(result);
  }

}