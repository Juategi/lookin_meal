import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/rating.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  MenuEntry entry;
  List<Rating> ratings;
  bool init = true;

  void _timer() {
    if(ratings == null) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        setState(() {
          print("Loading..");
        });
        _timer();
      });
    }
  }

  Future _update() async{

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    entry = ModalRoute.of(context).settings.arguments;
    if(init){
      _update();
      _timer();
      init = false;
    }
    return Container();
  }
}
