import 'package:flutter/material.dart';
import 'package:lookinmeal/models/list.dart';
import 'package:lookinmeal/screens/authenticate/authenticate.dart';
import 'package:lookinmeal/screens/authenticate/email_pass.dart';
import 'package:lookinmeal/screens/authenticate/log_in.dart';
import 'package:lookinmeal/screens/authenticate/sign_in.dart';
import 'package:lookinmeal/screens/home/home.dart';
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
import 'services/app_localizations.dart';
import 'screens/authenticate/wrapper.dart';
import 'services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() { Provider.debugCheckInvalidValueType = null; runApp(MyApp()); }


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    return StreamProvider<String>.value(
      value: AuthService().user,
      child: MaterialApp(
        darkTheme: ThemeData(brightness: Brightness.dark),
        routes:{
          "/wrapper":(context) => Wrapper(),
          "/home":(context) => Home(),
          "/authenticate": (context) => Authenticate(),
          "/login": (context) => LogIn(),
          "/signin": (context) => SignIn(),
          "/emailpass": (context) => EmailPassword(),
          "/restaurant": (context) => ProfileRestaurant(),
          "/editprofile": (context) => EditProfile(),
          "/editmenu" : (context) => EditMenu(),
          "/editorder" : (context) => EditOrder(),
          "/editrestaurant" : (context) => EditRestaurant(),
          "/editdaily" : (context) => EditDaily(),
          "/edittables" : (context) => EditTables(),
          "/favs" : (context) => Favorites(),
          "/gallery" : (context) => Gallery(),
          "/info" : (context) => RestaurantInfo(),
          "/admin": (context) => AdminPage(),
          "/ratinghistory": (context) => RatingHistory(),
          "/favslists" : (context) => FavoriteLists(),
          "/createlist" : (context) => CreateList(),
          "/displaylist" : (context) => ListDisplay(),
          "/comments" : (context) => Comments(),
          "/reservations" : (context) => ReservationsChecker(),
          "/tablereservations" : (context) => TableReservation(),
          "/userreservations" : (context) => UserReservations(),
          "/editcodes" : (context) => EditCodes(),
          "/newcode" : (context) => NewQRCode(),
          "/order" : (context) => OrderScreen()
        },
        home: Wrapper(),
        //initialRoute:"/",
        supportedLocales: [
          Locale('es','ES'),
          Locale('en','US')
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeListResolutionCallback: (locales, supportedLocales){
          for(var locale in locales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode)
                return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}