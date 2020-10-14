import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/favorites/favorites.dart';
import 'package:lookinmeal/screens/home/home_screen.dart';
import 'package:lookinmeal/screens/profile/profile.dart';
import 'package:lookinmeal/screens/search/search.dart';
import 'package:lookinmeal/screens/top/top.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:lookinmeal/services/auth.dart';
import 'package:lookinmeal/services/database.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/services/pool.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:lookinmeal/screens/map/map.dart';



class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
	final AuthService _auth = AuthService();
	final DBService _dbService = DBService();
	final GeolocationService _geolocationService = GeolocationService();
	User user;
	String id;
	String locality, country;
	Position myPos;
	List<Restaurant> nearRestaurants;
	Map<MenuEntry,Restaurant> popular;
	List<double> distances = List<double>();
	int _selectedIndex = 0;
	bool ready = false;

	void _onItemTapped(int index) {
		setState(()  {
			_selectedIndex = index;
		});
	}

	void _timer() {
		if(!ready || user == null) {
			Future.delayed(Duration(seconds: 2)).then((_) {
				setState(() {
					print("Loading..");
				});
				_timer();
			});
		}
	}


	void _update()async{
		myPos = await _geolocationService.getLocation();
		locality = await _geolocationService.getLocality(myPos.latitude, myPos.longitude);
		country = await _geolocationService.getCountry(myPos.latitude, myPos.longitude);
		nearRestaurants= await _dbService.getNearRestaurants(myPos.latitude, myPos.longitude, locality.toUpperCase());
		/*for(Restaurant restaurant in restaurants){
			distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
		}*/
		popular = await DBService.dbService.getPopular();
		ready = true;
	}

	@override
	Future<bool> didPopRoute() async {
		if(_selectedIndex == 0)
			return false;
		else {
			setState(() {
				_selectedIndex = 0;
			});
			return Future<bool>.value(true);
		}
	}

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_update();
		_timer();
	}

	@override
  Widget build(BuildContext context) {
	  user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
	  if(ready && user != null) {
			return Scaffold(
						body: Stack(
							children: <Widget>[
								Offstage(
									offstage: _selectedIndex != 0,
									child: TickerMode(
										enabled: _selectedIndex == 0,
										child: MultiProvider(
											providers: [
												Provider<Map<MenuEntry, Restaurant>>(create: (c) => popular,),
												Provider<List<Restaurant>>(create: (c) => nearRestaurants,)
											],
											child: HomeScreen(),
										)
									),
								),
								Offstage(
									offstage: _selectedIndex != 1,
									child: TickerMode(
										enabled: _selectedIndex == 1,
											child: MapSample()
									),
								),
								Offstage(
									offstage: _selectedIndex != 2,
									child: TickerMode(
											enabled: _selectedIndex == 2,
											child: Top()
									),
								),
								Offstage(
									offstage: _selectedIndex != 3,
									child: TickerMode(
										enabled: _selectedIndex == 3,
											child: Profile()
									),
								),

							],
						),
						bottomNavigationBar: BottomNavigationBar(
							backgroundColor: Colors.white,
							type: BottomNavigationBarType.fixed,
							items: <BottomNavigationBarItem>[
								BottomNavigationBarItem(
									icon: Icon(FontAwesomeIcons.compass, size: ScreenUtil().setSp(22),),
									title: Text(tr.translate("home")),
								),
								BottomNavigationBarItem(
									icon: Icon(FontAwesomeIcons.mapMarkedAlt, size: ScreenUtil().setSp(22),),
									title: Text(tr.translate("map")),
								),
								BottomNavigationBarItem(
									icon: Icon(Icons.star, size: ScreenUtil().setSp(25),),
									title: Text("Top"),
								),
								BottomNavigationBarItem(
									icon: Icon(Icons.person, size: ScreenUtil().setSp(25),),
									title: Text(tr.translate("profile")),
								),
							],
							currentIndex: _selectedIndex,
							selectedItemColor: Color.fromRGBO(255, 110, 117, 0.61),
							onTap: _onItemTapped,
						)
					);
		}
	  else
	  	return Loading();
  }
}
