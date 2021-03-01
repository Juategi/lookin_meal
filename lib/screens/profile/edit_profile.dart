import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/services/storage.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/strings.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  String country, image, username, name, about;
  String error = " ";
  bool init = true;

  @override
  Widget build(BuildContext context) {
    User user = DBServiceUser.userF;
    AppLocalizations tr = AppLocalizations.of(context);
    print(user.country);
    if(init){
      image = user.picture;
      country = user.country;
      name = user.name;
      username = user.username;
      about = user.about;
      init = false;
    }
    Function uploadImage = ()async{
      image = await _storageService.uploadImage(context,"images");
      if(image != null){
        setState((){
        });
      }
      else
        image = user.picture;
    };
    InputDecoration input = InputDecoration(
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(20)
        )
    );
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return SafeArea(
      child: Scaffold(
        //backgroundColor: CommonData().getColor(),
        body: Form(
          key: _formKey,
          child: ListView(
              children: <Widget>[
                //SizedBox(height: 30,),
                Container(
                  height: 42.h,
                  width: 411.w,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 110, 117, 0.9),
                  ),
                  child:Text("Edit Profile", maxLines: 1, textAlign: TextAlign.center, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24),),)),
                ),
                Container(
                  height: 190.h,
                  width: 411.w,
                  child: Stack(
                    children: [
                      Container(
                        height: 110.h,
                        width: 411.w,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 110, 117, 0.60),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: uploadImage,
                          child: Center(
                            child: Container(
                              height: 220.h,
                              width: 220.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle
                              ),
                              child: Center(
                                child: Container(
                                  height: 160.h,
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 143.h,
                                      width: 143.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey
                                      ),
                                      child: Center(
                                        child: Container(
                                          height: 136.h,
                                          width: 136.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: Image.network(image).image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 115.h,
                          left: 230.w,
                          child: GestureDetector(onTap: uploadImage, child: Icon(Icons.camera_alt, color: Color.fromRGBO(255, 110, 117, 1), size: ScreenUtil().setSp(44),))
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      SizedBox(height: 5,),
                      TextFormField(
                        onChanged: (value){
                          setState(() => username = value);
                        },
                        validator: (val) => val.isEmpty? tr.translate("entername") : null,
                        maxLength: 20,
                        decoration: input,
                        initialValue: user.username,
                      ),
                      Text(error, maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.red, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
                      SizedBox(height: 16,),
                      Text("Name", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      SizedBox(height: 5,),
                      TextFormField(
                        onChanged: (value){
                          setState(() => name = value);
                        },
                        validator: (val) => val.isEmpty ? tr.translate("entername") : null,
                        decoration: input,
                        maxLength: 50,
                        initialValue: user.name,
                      ),
                      SizedBox(height: 20,),
                      Text("Country", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.only(left: 10.w),
                        height: 60.h,
                        decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(20)),
                        child: CountryCodePicker(
                          onChanged: (c){
                            country = c.code;
                            print(country);
                          },
                          initialSelection: user.country,
                          showCountryOnly: true,
                          showOnlyCountryWhenClosed: true,
                          alignLeft: true,
                          showFlag: true,
                          showFlagDialog: true,
                          dialogTextStyle: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),),
                          searchStyle: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),),
                          textStyle: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("About yourself", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      SizedBox(height: 5,),
                      TextFormField(
                        onChanged: (value){
                          setState(() => about = value);
                        },
                        validator: (val) => val.isEmpty ? tr.translate("entername") : null,
                        decoration: input,
                        initialValue: user.about,
                        maxLines: 4,
                        maxLength: 300,
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: GestureDetector(
                          onTap: () async{
                            if(_formKey.currentState.validate()){
                              if(await DBServiceUser.dbServiceUser.checkUsername(username) == false || username == user.username){
                                setState(() {
                                  error = "";
                                });
                                DBServiceUser.dbServiceUser.updateUserData(user.uid, name, about, image, user.service, country, username);
                                user.username = username;
                                user.name = name;
                                user.country = country;
                                user.picture = image;
                                user. about = about;
                                Alerts.toast("User saved!");
                                Navigator.pop(context);
                              }
                              else{
                                setState(() {
                                  error = "Username taken";
                                });
                              }
                            }
                            else
                              print("error");
                          },
                          child: Container(
                            height: 50.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 110, 117, 0.9),
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            child: Center(child: Text("Save", maxLines: 1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white,
                                  letterSpacing: .3,
                                  fontWeight: FontWeight.normal,
                                  fontSize: ScreenUtil().setSp(22),),))),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}
