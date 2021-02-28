import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/services/storage.dart';
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
  String username, name, about = " ";
  String error = " ";

  @override
  Widget build(BuildContext context) {
    User user = DBServiceUser.userF;
    AppLocalizations tr = AppLocalizations.of(context);
    String image = user.picture;
    Function uploadImage = ()async{
      image = await _storageService.uploadImage(context,"images");
      if(image != null){
        //await _dbService.updateUserData(user.uid, user.email, user.name, image, user.service);
        if(user.picture != StaticStrings.defaultImage)
          await _storageService.removeFile(user.picture);
        user.picture = image;
        setState((){
        });
      }
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
    return Scaffold(
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
                      validator: (val) => val.isEmpty ? tr.translate("entername") : null,
                      decoration: input,
                      initialValue: user.username,
                    ),
                    SizedBox(height: 20,),
                    Text("Name", maxLines: 1, textAlign: TextAlign.start, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                    SizedBox(height: 5,),
                    TextFormField(
                      onChanged: (value){
                        setState(() => name = value);
                      },
                      validator: (val) => val.isEmpty ? tr.translate("entername") : null,
                      decoration: input,
                      initialValue: user.name,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(tr.translate("save"), style: TextStyle(color: Colors.white),),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    print("bien");
                  }
                },
              ),
              SizedBox(height: 12),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              )
            ]
        ),
      ),
    );
  }
}
