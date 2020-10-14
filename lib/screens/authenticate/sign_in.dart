import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/decos.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

	final _formKey = GlobalKey<FormState>();
	String username, country, name, error;
	bool loading;

	@override
  void initState() {
    super.initState();
		error = " ";
		username = "";
		country = "";
		name = "";
		loading = false;

  }

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
										Row( mainAxisAlignment: MainAxisAlignment.start,
											children: <Widget>[
												Text('Name', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
											],
										),
										SizedBox(height: 10.h,),
										TextFormField(
											onChanged: (value){
												setState(() => name = value);
											},
											style: TextStyle(
												color: Colors.white,
											),
											validator: (val) => val.isEmpty ? tr.translate("entername") : null,
											decoration: textInputDeco
										),
										Row( mainAxisAlignment: MainAxisAlignment.start,
											children: <Widget>[
												Text('Appears in your profile', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
											],
										),
										SizedBox(height: 20.h,),
										Row( mainAxisAlignment: MainAxisAlignment.start,
											children: <Widget>[
												Text('Username', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
											],
										),
										SizedBox(height: 10.h,),
										TextFormField(
											onChanged: (value){
												setState(() => username= value);
											},
											style: TextStyle(
												color: Colors.white,
											),
											validator: (val) => username.length < 3 ? "Username too short" : null,
											decoration: textInputDeco
										),
										Row( mainAxisAlignment: MainAxisAlignment.start,
											children: <Widget>[
												Text('This name helps users find you', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
											],
										),
										SizedBox(height: 20.h,),
										Row( mainAxisAlignment: MainAxisAlignment.start,
											children: <Widget>[
												Text('Country', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(16),),)),
											],
										),
										SizedBox(height: 10.h,),
										/*TextFormField(
											onChanged: (value){
												setState(() => country = value);
											},
											style: TextStyle(
												color: Colors.white,
											),
											validator: (val) => val.isEmpty ? "Write your country" : null,
											decoration: textInputDeco,
										),*/
										Container(
											padding: EdgeInsets.only(left: 10.w),
											height: 60.h,
											decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(20)),
										  child: CountryCodePicker(
										  	onChanged: (c){
										  		country = c.name;
										  		print(country);
										  	},
										  	initialSelection: 'ES',
										  	showCountryOnly: true,
										  	showOnlyCountryWhenClosed: true,
										  	alignLeft: true,
												showFlag: false,
												showFlagDialog: true,
										  	dialogTextStyle: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),),
										  	searchStyle: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),),
										  	textStyle: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),),
										  ),
										),
										Row( mainAxisAlignment: MainAxisAlignment.start,
											children: <Widget>[
												Text('Appears in your profile', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(12),),)),
											],
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
												child: !loading? Center(child: Text('Next', style: GoogleFonts.niramit(textStyle: TextStyle(color: Color.fromRGBO(255, 65, 112, 1), letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(18),),))) : CircularLoading(),
											),
											onTap: () async{
												if(_formKey.currentState.validate()) {
													setState(() {
														loading = true;
													});
													if(await DBService.dbService.checkUsername(username) == false){
														Navigator.pushNamed(context, "/emailpass", arguments: User(
															name: name,
															username: username,
															country: country,
														));
													}
													else{
														setState(() {
														  loading = false;
														  error = "Username taken";
														});
													}
												}
											},
										),
										SizedBox(height: 12),
										Text(
											error,
											style: TextStyle(color: Colors.red, fontSize: 14),
										),
									]
							),
		          ),
		        ),
		      ],
		    ),
		  ),
	  );
  }
}
