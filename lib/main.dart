import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lookinmeal/screens/home/home_screen.dart';
import 'package:lookinmeal/screens/authenticate/authenticate.dart';
import 'package:lookinmeal/screens/authenticate/email_pass.dart';
import 'package:lookinmeal/screens/authenticate/log_in.dart';
import 'package:lookinmeal/screens/authenticate/sign_in.dart';
import 'package:lookinmeal/screens/home/home.dart';
import 'package:lookinmeal/screens/profile/check_profile.dart';
import 'package:lookinmeal/screens/profile/edit_profile.dart';
import 'package:lookinmeal/screens/profile/favorites.dart';
import 'package:lookinmeal/screens/profile/my_reservations.dart';
import 'package:lookinmeal/screens/profile/rating_history.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_codes.dart';
import 'package:lookinmeal/screens/restaurants/admin/edit_tables.dart';
import 'file:///C:/D/lookin_meal/lib/screens/restaurants/admin/admin.dart';
import 'package:lookinmeal/screens/restaurants/comments.dart';
import 'file:///C:/D/lookin_meal/lib/screens/restaurants/admin/edit_daily.dart';
import 'file:///C:/D/lookin_meal/lib/screens/restaurants/admin/edit_menu.dart';
import 'file:///C:/D/lookin_meal/lib/screens/restaurants/admin/edit_order.dart';
import 'file:///C:/D/lookin_meal/lib/screens/restaurants/admin/edit_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/gallery.dart';
import 'package:lookinmeal/screens/restaurants/info.dart';
import 'package:lookinmeal/screens/restaurants/orders/order_screen.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/screens/restaurants/reservations.dart';
import 'package:lookinmeal/screens/restaurants/reserve_table.dart';
import 'package:lookinmeal/services/analytics.dart';
import 'package:lookinmeal/services/enviroment.dart';
import 'package:lookinmeal/services/payment.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:splashscreen/splashscreen.dart';
import 'screens/restaurants/admin/manage_orders.dart';
import 'services/app_localizations.dart';
import 'screens/authenticate/wrapper.dart';
import 'services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  InAppPurchaseConnection.enablePendingPurchases();
  Enviroment.init();
  InAppPurchasesService.initPlatformState();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(255, 110, 117, 0.5));
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return ScreenUtilInit(
            designSize: Size(CommonData.screenWidth.toDouble(),
                CommonData.screenHeight.toDouble()),
            builder: () =>
            StreamProvider<String>.value(
              value: AuthService().user,
              child: MaterialApp(
                navigatorObservers: [
                  //AnalyticsService().getAnalyticsObserver()
                ],
                theme: ThemeData(
                  scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),
                ),
                routes: {
                  "/wrapper": (context) => Wrapper(),
                  "/home": (context) => Home(),
                  "/homescreen": (context) => HomeScreen(),
                  "/authenticate": (context) => Authenticate(),
                  "/login": (context) => LogIn(),
                  "/signin": (context) => SignIn(),
                  "/emailpass": (context) => EmailPassword(),
                  "/restaurant": (context) => ProfileRestaurant(),
                  "/editprofile": (context) => EditProfile(),
                  "/editmenu": (context) => EditMenu(),
                  "/editorder": (context) => EditOrder(),
                  "/editrestaurant": (context) => EditRestaurant(),
                  "/editdaily": (context) => EditDaily(),
                  "/edittables": (context) => EditTables(),
                  "/favs": (context) => Favorites(),
                  "/gallery": (context) => Gallery(),
                  "/info": (context) => RestaurantInfo(),
                  "/admin": (context) => AdminPage(),
                  "/ratinghistory": (context) => RatingHistory(),
                  "/favslists": (context) => FavoriteLists(),
                  "/createlist": (context) => CreateList(),
                  "/displaylist": (context) => ListDisplay(),
                  "/comments": (context) => Comments(),
                  "/reservations": (context) => ReservationsChecker(),
                  "/tablereservations": (context) => TableReservation(),
                  "/userreservations": (context) => UserReservations(),
                  "/editcodes": (context) => EditCodes(),
                  "/newcode": (context) => NewQRCode(),
                  "/order": (context) => OrderScreen(),
                  "/addorder": (context) => AddMoreOrder(),
                  "/manageorder": (context) => ManageOrders(),
                  "/detailorder": (context) => OrderDetail(),
                  "/checkprofile": (context) => CheckProfile()
                },
                home: SplashScreen(
                    seconds: 1,
                    navigateAfterSeconds: Wrapper(),
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Find',
                            style: GoogleFonts.newsCycle(textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontWeight: FontWeight.normal,
                              fontSize: 72,),),),
                          TextSpan(text: 'Eat',
                              style: GoogleFonts.newsCycle(textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .5,
                                fontWeight: FontWeight.bold,
                                fontSize: 72,),))
                        ],
                      ),
                    ),
                    image: Image.asset('assets/logo.png'),
                    backgroundColor: Color.fromRGBO(255, 110, 117, 0.9),
                    styleTextUnderTheLoader: TextStyle(),
                    photoSize: 110.0,
                    loaderColor: Colors.white
                ),
                //initialRoute:"/",
                supportedLocales: [
                  Locale('es', 'ES'),
                  Locale('en', 'US')
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate
                ],
                localeListResolutionCallback: (locales, supportedLocales) {
                  for (var locale in locales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode == locale.languageCode &&
                          supportedLocale.countryCode == locale.countryCode)
                        return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
              ),
            ),
          );
          if (snapshot.hasError) {
            Alerts.dialog("Error", context);
          }
        return MaterialApp(
          home: SplashScreen(
              seconds: 1,
              navigateAfterSeconds: Wrapper(),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Find',
                      style: GoogleFonts.newsCycle(textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontWeight: FontWeight.normal,
                        fontSize: 72,),),),
                    TextSpan(text: 'Eat',
                        style: GoogleFonts.newsCycle(textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontWeight: FontWeight.bold,
                          fontSize: 72,),))
                  ],
                ),
              ),
              image: Image.asset('assets/logo.png'),
              backgroundColor: Color.fromRGBO(255, 110, 117, 0.9),
              styleTextUnderTheLoader: TextStyle(),
              photoSize: 110.0,
              loaderColor: Colors.white
          ),
        );
      }
    );
  }
}