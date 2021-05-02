import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lookinmeal/shared/common_data.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating, size;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, this.size, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        FontAwesomeIcons.star,
        color: color,
        size: size,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        FontAwesomeIcons.starHalfAlt,
        color: color ,
        size: size,
      );
    } else {
      icon = new Icon(
        FontAwesomeIcons.solidStar,
        color: color,
        size: size,
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(starCount, (index) => buildStar(context, index))
    );
  }
}

