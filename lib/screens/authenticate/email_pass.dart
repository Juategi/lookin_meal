import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/authenticate/wrapper.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class EmailPassword extends StatefulWidget {
  @override
  _EmailPasswordState createState() => _EmailPasswordState();
}

class _EmailPasswordState extends State<EmailPassword> {

  User user;
  final _formKey = GlobalKey<FormState>();
  String password = " ";
  String confirmPassword = " ";
  String error = " ";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.1,
                        0.3,
                        0.4,
                        0.8
                      ],
                      colors: [Color.fromRGBO(255, 138, 120, 0.72), Color.fromRGBO(255, 110, 117, 0.62), Color.fromRGBO(246, 120, 80, 0.61), Color.fromRGBO(255, 67, 112, 1)],
                    )
                )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.h,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Find', style: GoogleFonts.newsCycle(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(72),),)),
                        Text('Eat', style: GoogleFonts.newsCycle(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(72),),)),
                      ],
                    ),
                    SizedBox(height: 40.h,),
                    Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Email', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    TextFormField(
                        onChanged: (value){
                          setState(() => user.email = value);
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (val) => !RegExp(StaticStrings.emailReg).hasMatch(val) ? tr.translate("entername") : null,
                        decoration: textInputDeco
                    ),
                    Text(error, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.red, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                    SizedBox(height: 20.h,),
                    Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Password', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    TextFormField(
                      obscureText: true,
                        onChanged: (value){
                          setState(() => password = value);
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (val) => password.length < 8 ? "Password too short" : null,
                        decoration: textInputDeco
                    ),
                    SizedBox(height: 20.h,),
                    Row( mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Confirm password', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    TextFormField(
                      obscureText: true,
                        onChanged: (value){
                          setState(() => confirmPassword = value);
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (val) => password != confirmPassword ? "Passwords don't match" : null,
                        decoration: textInputDeco
                    ),
                    SizedBox(height: 50.h,),
                    GestureDetector(
                      child: Container(
                        height: 56.h,
                        width: 280.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Colors.white
                        ),
                        child: !loading? Center(child: Text('Confirm', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))) : CircularLoading(),
                      ),
                      onTap: () async{
                        setState(() {
                          error = "";
                        });
                        if(_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          if((await DBServiceUser.dbServiceUser.checkUsernameEmail(user.username, user.email)).contains("e") == false){
                            dynamic result = AuthService().registerEP(user.email, password, user.name, user.country, user.username);
                            if(result == null){
                              setState(() {
                                loading = false;
                                error = "Error";
                              });
                            }
                            else{
                              Future.delayed(Duration(seconds: 3)).then((_) {
                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(name: "/wrapper"),
                                  screen: Wrapper(),
                                  withNavBar: false,
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              });
                              //Navigator.pushNamedAndRemoveUntil(context, "/wrapper",  (Route<dynamic> route) => false);
                            }
                          }
                          else{
                            setState(() {
                              loading = false;
                              error = "Email taken";
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 40.h,),
                    Text('By signing up you agree to our Terms and conditions of use.', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(13),),)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
