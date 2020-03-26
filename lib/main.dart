import 'package:flutter/material.dart';
import 'package:lookinmeal/screens/authenticate/authenticate.dart';
import 'package:lookinmeal/screens/authenticate/log_in.dart';
import 'package:lookinmeal/screens/authenticate/sign_in.dart';
import 'package:lookinmeal/screens/home/home.dart';
import 'package:lookinmeal/screens/profile/edit_profile.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'services/app_localizations.dart';
import 'models/user.dart';
import 'screens/authenticate/wrapper.dart';
import 'services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        routes:{
          //"/":(context) => Wrapper(),
          "/home":(context) => Home(),
          "/authenticate": (context) => Authenticate(),
          "/login": (context) => LogIn(),
          "/signin": (context) => SignIn(),
          "/restaurant": (context) => ProfileRestaurant(),
          "/editprofile": (context) => EditProfile(),
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