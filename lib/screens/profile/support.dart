import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';

class SupportMenu extends StatefulWidget {
  @override
  _SupportMenuState createState() => _SupportMenuState();
}

class _SupportMenuState extends State<SupportMenu> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h,),
          Text("Support and help", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 80.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                //settings: RouteSettings(name: "/owner"),
                screen: TicketMenu(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.support_agent, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Send a ticket", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){

            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.find_in_page_sharp, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Read terms of service", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketMenu extends StatefulWidget {
  @override
  _TicketMenuState createState() => _TicketMenuState();
}

class _TicketMenuState extends State<TicketMenu> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    return Scaffold(
      body: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h,),
          Text("Ticket issue", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
          SizedBox(height: 80.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments: "Q"),
                screen: SendTicket(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.mark_chat_read, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Suggestion or question", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments: "P"),
                screen: SendTicket(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.payments_outlined, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Payment problem", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments: "R"),
                screen: SendTicket(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 60.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.warning_sharp, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, child: Text("Report a misuse of a local's profile", maxLines: 2, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),
          GestureDetector(
            onTap:(){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(arguments: "B"),
                screen: SendTicket(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Container(
              width: 365.w,
              height: 80.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w,),
                  Icon(Icons.bug_report, size: ScreenUtil().setSp(35), color: Color.fromRGBO(70, 70, 70, 1),),
                  SizedBox(width: 30.w,),
                  Container(width: 250.w, height: 80.h, child: Text("I have found an error or a malfunction in some part of the app", maxLines: 3, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),))),
                  Text(">", maxLines: 1, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18),),)),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h,),

        ],
      ),
    );
  }
}

class SendTicket extends StatefulWidget {
  @override
  _SendTicketState createState() => _SendTicketState();
}

class _SendTicketState extends State<SendTicket> {
  String type, ticket;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
    type =  ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: ListView(
          children: [
            SizedBox(height: 40.h,),
            Text("Please explain your problem with details", maxLines: 3, style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.black, letterSpacing: .3, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(25),),)),
            SizedBox(height: 80.h,),
            TextField(
              onChanged: (value){
                setState(() => ticket = value);
              },
              decoration: InputDecoration(
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
              ),
              maxLines: 15,
              maxLength: 1200,
            ),
            SizedBox(height: 40.h,),
            GestureDetector(
              onTap: () async {
                if(ticket == null || ticket.length == 0){
                  Alerts.dialog("Please write something", context);
                }
                else{
                  await DBServiceUser.dbServiceUser.createTicket(ticket, type);
                  Alerts.toast("Ticket created! We will contact you soon");
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 50.h,
                width: 200.w,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 110, 117, 0.9),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Center(child: Text("Send", maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.niramit(textStyle: TextStyle(color: Colors.white,
                      letterSpacing: .3,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(22),),))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
