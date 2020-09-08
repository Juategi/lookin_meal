import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/screens/restaurants/entry.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'package:provider/provider.dart';

class TopDishesTile extends StatefulWidget {
  @override
  _TopDishesTileState createState() => _TopDishesTileState();
}

class _TopDishesTileState extends State<TopDishesTile> with TickerProviderStateMixin {
  MenuEntry entry;

  @override
  Widget build(BuildContext context) {
    entry = Provider.of<MenuEntry>(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Card(
          elevation: 0 ,
          child: Container(
            width: 110.w,
            height: 110.h,
            //color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  width: 110.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: Image.network(entry.image, fit: BoxFit.cover).image)
                  ),
                )
              ],
            )
          ),
        ),
      ),
      onTap: () async{
        await showModalBottomSheet(context: context, isScrollControlled: true, builder: (BuildContext bc){
          return EntryRating(entry);
        }).then((value){setState(() {});});
      },
    );
  }
}
