import 'package:flutter/material.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Menu extends StatelessWidget {
  List<String> sections;
  List<MenuEntry> menu;
  String currency;
  Menu({this.menu, this.sections, this.currency});

  List<Widget> _initList(){
    List<Widget> entries = new List<Widget>();
    for(String section in sections){
      entries.add(Text(section));
      for(MenuEntry entry in menu){
        if(section == entry.section){
          entries.add(ListTile(
            title: Text("${entry.name}   ${entry.price} $currency"),
            subtitle: Row(children: <Widget>[
              SmoothStarRating(allowHalfRating: true, rating: entry.rating, filledIconData: Icons.star, halfFilledIconData: Icons.star_half),
              Text(" (${entry.numReviews})")],),
            trailing: Image.network(entry.image ?? "https://sevilla.abc.es/gurme/wp-content/uploads/sites/24/2012/01/comida-rapida-casera.jpg"),
          ));
        }
      }
      entries.add(SizedBox(height: 5,));
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    if(sections != null){
      return Column(
          children: _initList()
      );
    }
    else return Container();
  }
}
