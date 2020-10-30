import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';

class Functions{

  static int getVotes(Restaurant restaurant){
    int votes = 0;
    for(MenuEntry entry in restaurant.menu){
      votes += entry.numReviews;
    }
    return votes;
  }
  static double getRating(Restaurant restaurant){
    double totalRating = 0.0;
    int counter = 0;
    for(MenuEntry entry in restaurant.menu){
      if(entry.numReviews > 0) {
        totalRating += entry.rating;
        counter++;
      }
    }
    if(totalRating == 0.0)
      return 0.0;
    return totalRating/counter;
  }

  static bool compareList(List<String> l1, List<String> l2){
    print(l1);
    print(l2);
    if(l1.length != l2.length)
      return false;
    for(String s in l1){
      if(!l2.contains(s))
        return false;
    }
    return true;
  }

  static String limitString(String s, int n){
    if(s.length > n){
      return "${s.substring(0,n-3)}...";
    }
    else return s;
  }

  static List<String> cleanStrings(List<String> list){
    List<String> aux = [];
    for(String s in list){
      aux.add(s.replaceAll("'", ""));
    }
    return aux;
  }
}