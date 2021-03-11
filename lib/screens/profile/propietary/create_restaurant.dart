import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:lookinmeal/database/requestDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'file:///C:/D/lookin_meal/lib/screens/profile/propietary/find_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/functions.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/widgets.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CreateRestaurant extends StatefulWidget {
  @override
  _CreateRestaurantState createState() => _CreateRestaurantState();
}

class _CreateRestaurantState extends State<CreateRestaurant> {
  String relation = "Dueño";
  String currency = "€";
  String name, website, phone, address, city, country, image, email;
  List<String> types;
  double latitude, longitude;
  bool sent = false;
  final StorageService _storageService = StorageService();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: sent? Column(
            children: [
              SizedBox(height: 50.h,),
              Text("Thank you, our team will review your application and will contact you soon.", maxLines: 5, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
            ],
          ) :  ListView(
            children: [
              GestureDetector(
                onTap: () async{
                  image = await _storageService.uploadImage(context, "restaurantrequest");
                  if(image != null){
                    setState((){
                    });
                  }
                },
                child: Container(
                  width: 410.w,
                  height: 130.h,
                  decoration: image == null? null: BoxDecoration(
                    image: DecorationImage(
                      image: Image.network(image).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Icon(Icons.camera_alt, size: ScreenUtil().setSp(55), color: Color.fromRGBO(255, 110, 117, 0.7),)
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Name", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Center(
                child: TextField(
                  onChanged: (val){
                    name = val;
                  },
                  maxLines: 1,
                  maxLength: 150,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  decoration: textInputDeco.copyWith(hintText: "Name here"),
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Location", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Container(
                  width: 400.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.black)
                  ),
                  child: Center(child: Text(address ?? "Address..", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),)))
              ),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: "AIzaSyAIIK4P68Ge26Yc0HkQ6uChj_NEqF2VeCU",
                        autocompleteLanguage: "es",
                        desiredLocationAccuracy: LocationAccuracy.high,
                        hintText: "Buscar",
                        searchingText: "Buscando..",
                        onPlacePicked: (result) async {
                          print(result.formattedAddress);
                          address = result.formattedAddress;
                          latitude = result.geometry.location.lat;
                          longitude = result.geometry.location.lng;
                          city = await GeolocationService().getLocality(latitude, longitude);
                          country = await GeolocationService().getCountry(latitude, longitude);
                          print(country);
                          print(city);
                          setState(() {
                          });
                          Navigator.of(context).pop();
                        },
                        initialPosition: latitude == null? LatLng(GeolocationService.myPos.latitude, GeolocationService.myPos.longitude) : LatLng(latitude, longitude),
                        useCurrentLocation: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 382.w,
                  height: 92.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(address == null? 'https://miro.medium.com/max/4064/1*qYUvh-EtES8dtgKiBRiLsA.png' : 'https://maps.googleapis.com/maps/api/staticmap?center=${address}&zoom=15&size=900x600&maptype=roadmap&markers=color:red%7Clabel:.%7C${latitude},${longitude}&key=AIzaSyAIIK4P68Ge26Yc0HkQ6uChj_NEqF2VeCU'))
                  ),
                  child: Center(
                    child: Icon(Icons.location_on, size: ScreenUtil().setSp(55), color: Color.fromRGBO(255, 110, 117, 0.7),)
                  ),
                ),
              ),
              SizedBox(height: 30.h,),
              Text("Website", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Center(
                child: TextField(
                  onChanged: (val){
                    website = val;
                  },
                  maxLines: 1,
                  maxLength: 150,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  decoration: textInputDeco.copyWith(hintText: "Website here"),
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Email", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Center(
                child: TextField(
                  onChanged: (val){
                    email = val;
                  },
                  maxLines: 1,
                  maxLength: 50,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  decoration: textInputDeco.copyWith(hintText: "Email here"),
                ),
              ),
              SizedBox(height: 20.h,),
              Text("Phone", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              Center(
                child: TextField(
                  onChanged: (val){
                    phone = val;
                  },
                  maxLines: 1,
                  maxLength: 50,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  decoration: textInputDeco.copyWith(hintText: "Phone here"),
                ),
              ),
              SizedBox(height: 20.h,),
              Container(child: MultiSelect(
                //autovalidate: false,
                titleText: "Restaurant types",
                /*validator: (value) {
                                if (value == null) {
                                  return 'Please select one or more option(s)';
                                }
                                else
                                  return "";
                              },*/
                //errorText: 'Please select one or more option(s)',
                dataSource: CommonData.types,
                textField: 'value',
                valueField: 'value',
                filterable: true,
                required: true,
                value: null,
                initialValue: types,
                maxLength: 20,
                change: (value) {
                  types = List<String>.from(value);
                },
              ),),
              SizedBox(height: 20,),
              Text("Currency", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10,),
              DropdownButton(
                value: currency,
                elevation: 1,
                items: [
                  DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text("€", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                        SizedBox(width: 50.w,)
                      ],
                    ),
                    value: "€",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text("\$", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                        SizedBox(width: 50.w,)
                      ],
                    ),
                    value: "\$",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text("£", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                        SizedBox(width: 50.w,)
                      ],
                    ),
                    value: "£",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Text("¥", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14),),)),
                        SizedBox(width: 50.w,)
                      ],
                    ),
                    value: "¥",
                  ),
                ],
                onChanged: (selected) async{
                  setState(() {
                    currency = selected;
                  });
                },
              ),
              SizedBox(height: 30,),
              Text("Relation with the place", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20),),)),
              SizedBox(height: 10.h,),
              DropdownButton<String>(
                items: CommonData.typesRelation.map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: 140.w, child: Text(type, maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
                      ],
                    )
                )).toList(),
                underline: Padding(
                  padding: EdgeInsets.all(5),
                ),
                value: relation,
                onChanged: (type) async{
                  setState(() {
                    relation = type;
                  });
                },
              ),
              SizedBox(height: 30.h,),
              GestureDetector(
                onTap: (){
                  DBServiceRequest.dbServiceRequest.createRequestRestaurant(DBServiceUser.userF.uid, relation, name, phone, website, address, email, city, country, latitude, longitude, image, types, currency);
                  setState(() {
                    sent = true;
                  });
                },
                child: Container(
                    width: 170.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 110, 117, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(child: Text("Send", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(18),),)))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
