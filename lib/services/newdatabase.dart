import 'package:postgres/postgres.dart';

class DBServiceN{

  final connection = new PostgreSQLConnection("104.155.57.239", 5432, "lookinmeal", username: "postgres", password: "qHeNfB1d5jNOrf8o", useSSL: true);
  Future updateRestaurantData(String id, String name, String phone, String website, String webUrl, String address, String email, String city, String country, double latitude,
      double longitude, double rating, int numberViews, List<String> images, List<String> types, Map<String,List<int>> schedule )async{
    List<String> sections = ["Entrantes", "Carnes", "Postres"];
    String query = "INSERT INTO restaurant(ta_id,name,address,city,country,email,phone,website,types,images,schedule,rating,latitude,longitude,numRevta,sections,currency) VALUES (@id,@name,@address,@city,@country,@email,@phone,@website,@types,@images,@schedule,@rating,@latitude,@longitude,@numberViews,@sections,@currency)";
    print(query);
    await connection.open();
    /*await connection.transaction((ctx) async {
      await ctx.query(query,substitutionValues:{
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "country": country,
        "email": email,
        "phone": phone,
        "website": website,
        "types": "ARRAY$types",
        "schedule": schedule,
        "rating": rating,
        "latitude": latitude,
        "longitude": longitude,
        "numberViews": numberViews,
        "sections": "ARRAY$sections",
        "currency": "€"
      });
    });*/
    await connection.transaction((ctx) async {
      dynamic result = await ctx.query("SELECT * FROM pg_catalog.pg_tables;");
      print(result);
    });
    connection.close();
  }

}