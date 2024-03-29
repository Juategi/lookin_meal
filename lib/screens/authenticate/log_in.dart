import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/screens/authenticate/sign_in.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

	final AuthService _auth = AuthService();
	final _formKey = GlobalKey<FormState>();
	String email, password, error = " ";

  @override
  Widget build(BuildContext context) {
	  AppLocalizations tr = AppLocalizations.of(context);

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
											Text( tr.translate("email"), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
										],
									),
									SizedBox(height: 10.h,),
										TextFormField(
												onChanged: (value){
													setState(() => email = value);
												},
												style: TextStyle(
													color: Colors.white,
												),
												validator: (val) => !RegExp(StaticStrings.emailReg).hasMatch(val) ? tr.translate("enteremail") : null,
												decoration: textInputDeco
										),
									SizedBox(height: 25.h,),
									Row( mainAxisAlignment: MainAxisAlignment.start,
										children: <Widget>[
											Text( tr.translate("passw"), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
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
										validator: (val) => val.length < 6 ? tr.translate("enterpassw") : null,
										decoration: textInputDeco,
									),
									SizedBox(height: 10.h,),
									Center(child: Text(error, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.red, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
									SizedBox(height: 50.h,),
									GestureDetector(
									  child: Container(
									  	height: 56.h,
									  	width: 280.w,
									  	decoration: BoxDecoration(
									  			borderRadius: BorderRadius.all(Radius.circular(16)),
									  			color: Colors.white
									  	),
									  	child: Center(child: Text( tr.translate("login"), style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
									  ),
										onTap: () async{
											if(_formKey.currentState.validate()){
												dynamic result = await _auth.signInEP(email, password);
												print(result);
												if(result == null)
													setState(() {
														error = tr.translate("validmail");
													});
												else
													Navigator.pop(context);
											}
										},
									),
									SizedBox(height: 100.h,),
									Row(
									  children: <Widget>[
									    Text( tr.translate("donthaveaccount"), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(15),),)),
											SizedBox(width: 2.w,),
											GestureDetector(
												onTap: () => pushNewScreenWithRouteSettings(
													context,
													settings: RouteSettings(name: "/signin"),
													screen: SignIn(),
													withNavBar: false,
													pageTransitionAnimation: PageTransitionAnimation.cupertino,
												), //Navigator.pushNamed(context, "/signin"),
													child: Text(tr.translate("signupnow"), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(16),),))
											),
										],
									),
									SizedBox(height: 30.h,),
									GestureDetector(
											child: Center(child: Text(tr.translate("forgot"), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(17),),)))),
								],
					    ),
					  ),
					)
				],
			),
		  )
	  );
  }
}
