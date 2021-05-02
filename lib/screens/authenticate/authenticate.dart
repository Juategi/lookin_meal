import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookinmeal/screens/authenticate/log_in.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Authenticate extends StatefulWidget {

	@override
	_AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

	final AuthService _auth = AuthService();

	@override
	Widget build(BuildContext context) {

		AppLocalizations tr = AppLocalizations.of(context);
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
									colors: [Color.fromRGBO(255, 138, 120, 0.72), Color.fromRGBO(255, 110, 117, 0.62), Color.fromRGBO(246, 120, 80, 0.61), Color.fromRGBO(255, 67, 112, 1)],
			    			)
			    	)
			    ),
					Center(
					  child: Column( mainAxisAlignment: MainAxisAlignment.center,
					  	children: <Widget>[
					  		Row(mainAxisAlignment: MainAxisAlignment.center,
					  		  children: <Widget>[
					  		    Text('Find', style: GoogleFonts.newsCycle(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(72),),)),
										Text('Eat', style: GoogleFonts.newsCycle(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(72),),)),
									],
					  		),
								SizedBox(height: 60.h,),
								GestureDetector(
								  child: Stack(
								    children: <Widget>[
								  		Container(
								  			height: 56.h,
								  			width: 280.w,
								  			decoration: BoxDecoration(
								  					borderRadius: BorderRadius.all(Radius.circular(28)),
								  					border: Border.all(width: 1, color: Colors.white, style: BorderStyle.solid)
								  			),
								  			child: Row( mainAxisAlignment: MainAxisAlignment.center,
								  			  children: <Widget>[
								  			  	SizedBox(width: 20.w,),
								  			    Text(tr.translate('facebook'), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
								  			  ],
								  			),
								  		),
								  		Positioned(
								  			right: 222.w,
								  		  top: 0.h,
								  		  child: Container(
								  		  	width: 60.w,
								  		  	height: 60.h,
								  		  	decoration: new BoxDecoration(
								  		  		border: Border.all(color:Colors.white),
								  		  		color: Colors.white,
								  		  		shape: BoxShape.circle,
								  		  	),
								  		  	child: Center(
								  		  		child: Container(
								  		  				height: 47.h,
								  		  				width: 38.w,
								  		  				child: SvgPicture.asset("assets/facebook.svg")
								  		  		),
								  		  	),
								  		  ),
								  		),
								    ],
								  ),
									onTap: () async{
										PermissionStatus permission = await LocationPermissions().requestPermissions();
										if(permission == PermissionStatus.granted) {
											await GeolocationService().getLocation();
											await _auth.loginFB();
										}
									},
								),
								SizedBox(height: 30.h,),
								GestureDetector(
									child: Stack(
										children: <Widget>[
											Container(
												height: 56.h,
												width: 280.w,
												decoration: BoxDecoration(
														borderRadius: BorderRadius.all(Radius.circular(28)),
														border: Border.all(width: 1, color: Colors.white, style: BorderStyle.solid)
												),
												child: Row( mainAxisAlignment: MainAxisAlignment.center,
													children: <Widget>[
														SizedBox(width: 20.w,),
														Text(tr.translate('google'), style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
													],
												),
											),
											Positioned(
												right: 222.w,
												top: 0.h,
												child: Container(
													width: 60.w,
													height: 60.h,
													decoration: new BoxDecoration(
														border: Border.all(color:Colors.white),
														color: Colors.white,
														shape: BoxShape.circle,
													),
													child: Center(
														child: Container(
																height: 47.h,
																width: 38.w,
																child: SvgPicture.asset("assets/google.svg")
														),
													),
												),
											),
										],
									),
									onTap: () async{
										PermissionStatus permission = await LocationPermissions().requestPermissions();
										if(permission == PermissionStatus.granted) {
											await GeolocationService().getLocation();
											await _auth.loginGoogle();
										}
									}
								),
								SizedBox(height: 30.h,),
								GestureDetector(
										child: Stack(
											children: <Widget>[
												Container(
													height: 56.h,
													width: 280.w,
													decoration: BoxDecoration(
															borderRadius: BorderRadius.all(Radius.circular(28)),
															border: Border.all(width: 1, color: Colors.white, style: BorderStyle.solid)
													),
													child: Row( mainAxisAlignment: MainAxisAlignment.center,
														children: <Widget>[
															SizedBox(width: 20.w,),
															Text('Log in with Email', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(14),),)),
														],
													),
												),
												Positioned(
													right: 222.w,
													top: 0.h,
													child: Container(
														width: 60.w,
														height: 60.h,
														decoration: new BoxDecoration(
															border: Border.all(color:Colors.white),
															color: Colors.white,
															shape: BoxShape.circle,
														),
														child: Center(
															child: Container(
																	height: 47.h,
																	width: 38.w,
																	child: SvgPicture.asset("assets/email.svg")
															),
														),
													),
												),
											],
										),
										onTap: ()async{
											PermissionStatus permission = await LocationPermissions().requestPermissions();
											if(permission == PermissionStatus.granted) {
												GeolocationService().getLocation();
												pushNewScreenWithRouteSettings(
													context,
													settings: RouteSettings(name: "/login"),
													screen: LogIn(),
													withNavBar: false,
													pageTransitionAnimation: PageTransitionAnimation.cupertino,
												);
												//await Navigator.pushNamed(context, "/login");
											}
									},
								),
								SizedBox(height: 40.h,),
								Padding(
								  padding: EdgeInsets.symmetric(horizontal: 60.w),
								  child: Text('By signing up you agree to our Terms and conditions of use.', style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white, letterSpacing: .3, fontWeight: FontWeight.normal, fontSize: ScreenUtil().setSp(13),),)),
								),
							],
					  ),
					),
			  ],
			),
		);
	}
}
