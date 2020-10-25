import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';

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
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
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
													setState(() => email = value);
												},
												style: TextStyle(
													color: Colors.white,
												),
												validator: (val) => !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? tr.translate("enteremail") : null,
												decoration: textInputDeco
										),
									SizedBox(height: 25.h,),
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
										validator: (val) => val.length < 6 ? tr.translate("enterpassw") : null,
										decoration: textInputDeco,
									),
									SizedBox(height: 70.h,),
									GestureDetector(
									  child: Container(
									  	height: 56.h,
									  	width: 280.w,
									  	decoration: BoxDecoration(
									  			borderRadius: BorderRadius.all(Radius.circular(16)),
									  			color: Colors.white
									  	),
									  	child: Center(child: Text('LOG IN', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))),
									  ),
										onTap: () async{
											if(_formKey.currentState.validate()){
												dynamic result = await _auth.signInEP(email, password);
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
									    Text("Don't have an account? ", style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(17),),)),
											GestureDetector(
												onTap: () => Navigator.pushNamed(context, "/signin"),
													child: Text("Sign up now.", style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(17),),))),
										],
									),
									SizedBox(height: 30.h,),
									GestureDetector(
											child: Center(child: Text("Forgot password?", style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(17),),)))),
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
