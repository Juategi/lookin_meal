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
    for(MenuEntry entry in restaurant.menu){
      totalRating += entry.rating;
    }
    if(totalRating == 0.0)
      return 0.0;
    return totalRating/restaurant.menu.length;
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
}