import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

	final AuthService _auth = AuthService();
	final _formKey = GlobalKey<FormState>();
	String email, password, name = " ";
	String error = " ";

  @override
  Widget build(BuildContext context) {
	  AppLocalizations tr = AppLocalizations.of(context);
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
		return Scaffold(
		  body: Stack(
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
											colors: [Color.fromRGBO(255, 138, 120, 0.72), Color.fromRGBO(255, 110, 117, 0.62), Color.fromRGBO(246, 120, 80, 0.61), Color.fromRGBO(255, 67, 112, 1)]
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
										TextFormField(
											onChanged: (value){
												setState(() => name = value);
											},
											validator: (val) => val.isEmpty ? tr.translate("entername") : null,
											decoration: textInputDeco.copyWith(hintText: tr.translate("name"))
										),
										SizedBox(height: 20,),
										TextFormField(
											onChanged: (value){
												setState(() => email = value);
											},
											validator: (val) => val.isEmpty ? tr.translate("enteremail") : null,
											decoration: textInputDeco.copyWith(hintText: tr.translate("email"))
										),
										SizedBox(height: 20,),
										TextFormField(
											obscureText: true,
											onChanged: (value){
												setState(() => password = value);
											},
											validator: (val) => val.length < 6 ? tr.translate("enterpassw") : null,
											decoration: textInputDeco.copyWith(hintText: tr.translate("passw")),
										),
									 SizedBox(height: 20,),
										RaisedButton(
											color: Colors.pink[400],
											child: Text(tr.translate("register"), style: TextStyle(color: Colors.white),),
											onPressed: () async{
											if(_formKey.currentState.validate()){
												dynamic result = await _auth.registerEP(email, password, name, "", "");
												if(result == null)
													setState(() {
														error = tr.translate("validmail");
													});
												else
													Navigator.pop(context);
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
		      ),
		    ],
		  ),
	  );
  }
}
