import 'package:flutter_screenutil/screenutil.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:provider/provider.dart';


class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    restaurant = ModalRoute.of(context).settings.arguments;
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GridView.count(
          crossAxisCount: 3,
          scrollDirection: Axis.vertical,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          children: restaurant.images.map((image) =>
              GestureDetector(
                child: Container(
                  height: 230,
                  width: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: Container(
                        child: PhotoView(
                          imageProvider: NetworkImage(image),
                        )
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return Container(
                        child: PhotoView(
                          imageProvider: NetworkImage(image),
                        )
                    );
                  }));*/
                }
              ),).toList(),
        ),
      ),
    );
  }
}


