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
    if(list == null)
      return aux;
    for(String s in list){
      aux.add(s.replaceAll("'", "").replaceAll("'", ""));
    }
    return aux;
  }

  static List<String> copyList(List<String> list){
    List<String> aux = [];
    if(list == null)
      return aux;
    for(String s in list){
      aux.add(s);
    }
    return aux;
  }

  static String formatDate(String date){
    String date2 = date.substring(8) + "/" + date.substring(5,7) + "/" + date.substring(0,4);
    return date2;
  }

  static int compareDates(String date1, String date2){
    if(date1 == date2)
      return 0;
    if(int.parse(date1.substring(0,4)) - int.parse(date2.substring(0,4)) != 0)
      return int.parse(date1.substring(0,4)) - int.parse(date2.substring(0,4));
    if(int.parse(date1.substring(5,7)) - int.parse(date2.substring(5,7)) != 0)
      return int.parse(date1.substring(5,7)) - int.parse(date2.substring(5,7));
    if(int.parse(date1.substring(8)) - int.parse(date2.substring(8)) != 0)
      return int.parse(date1.substring(8)) - int.parse(date2.substring(8));
    return 0;
  }

  static String parseSchedule(List<String> hours){
    String text = "";
    for(int i = 0; i < hours.length; i+=2){
      hours[i] = hours[i].replaceAll("[", "").replaceAll("]", "").trim();
      hours[i+1] = hours[i+1].replaceAll("[", "").replaceAll("]", "").trim();
      if(hours[i].toString() != "-1"){
        if(hours[i].toString().length == 2){
          text += hours[i].toString() + ":00" ;
        }
        else{
          text += hours[i].toString().substring(0,2) + ":" + hours[i].toString().substring(2,4);
        }
        text += " - ";
        if(hours[i+1].toString().length == 2){
          text += hours[i+1].toString() + ":00" ;
        }
        else{
          text += hours[i+1].toString().substring(0,2) + ":" + hours[i+1].toString().substring(2,4);
        }
        text += "     ";
      }
    }
    return text;
  }

}