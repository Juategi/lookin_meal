import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/home/home_screen.dart';
import 'package:lookinmeal/screens/profile/profile.dart';
import 'package:lookinmeal/screens/restaurants/orders/order_screen.dart';
import 'package:lookinmeal/screens/top/top.dart';
import 'package:lookinmeal/services/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lookinmeal/services/push_notifications.dart';
import 'package:lookinmeal/shared/common_data.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:lookinmeal/screens/map/map.dart';
import 'file:///C:/D/lookin_meal/lib/database/userDB.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:minimize_app/minimize_app.dart';



class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
	final GeolocationService _geolocationService = GeolocationService();
	User user;
	String id;
	String locality, country;
	Position myPos;
	List<Restaurant> nearRestaurants;
	Map<MenuEntry,Restaurant> popular;
	List<double> distances = List<double>();
	int lastIndex = 0;
	bool ready = false;
	Color selectedItemColor = Color.fromRGBO(255, 110, 117, 0.61);
	Color unselectedItemColor = Color.fromRGBO(130, 130, 130, 1);
	PersistentTabController _controller = PersistentTabController(initialIndex: 0);

	void onItemTapped(int index) {
		setState(()  {
			CommonData.selectedIndex = index;
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
		nearRestaurants= await DBServiceRestaurant.dbServiceRestaurant.getNearRestaurants(myPos.latitude, myPos.longitude, locality.toUpperCase());
		/*for(Restaurant restaurant in restaurants){
			distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
		}*/
		popular = await DBServiceRestaurant.dbServiceRestaurant.getPopular();
		ready = true;
	}

	Future<void> scanQR() async {
		if(DBServiceUser.userF.inOrder == null){
			String barcodeScanRes;
			// Platform messages may fail, so we use a try/catch PlatformException.
			try {
				barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
						"#FF6E75", "Cancel", true, ScanMode.QR);
				print(barcodeScanRes);
			} on PlatformException {
				barcodeScanRes = 'Failed to get platform version.';
			}
			// If the widget was removed from the tree while the asynchronous platform
			// message was in flight, we want to discard the reply rather than calling
			// setState to update our non-existent appearance.
			if (!mounted) return;

			if(barcodeScanRes != "-1")
				if(RegExp(r'[a-zA-Z0-9]+/+[a-zA-Z0-9]').hasMatch(barcodeScanRes))
					pushNewScreenWithRouteSettings(
						context,
						settings: RouteSettings(name: "/order", arguments: barcodeScanRes),
						screen: OrderScreen(),
						withNavBar: true,
						pageTransitionAnimation: PageTransitionAnimation.slideUp,
					).then((value) => setState(() {}));
					//Navigator.pushNamed(context, "/order",arguments: barcodeScanRes).then((value) => setState(() {}));
				else
					setState(() {
						_controller.jumpToTab(0);
					});
		}
		else{
			pushNewScreenWithRouteSettings(
				context,
				settings: RouteSettings(name: "/order", arguments: DBServiceUser.userF.inOrder),
				screen: OrderScreen(),
				withNavBar: true,
				pageTransitionAnimation: PageTransitionAnimation.slideUp,
			).then((value) => setState(() {}));
			//Navigator.pushNamed(context, "/order",arguments: DBServiceUser.userF.inOrder).then((value) => setState(() {}));
		}
	}

	BottomNavigationBar getBar(){
		AppLocalizations tr = AppLocalizations.of(context);
		return BottomNavigationBar(
			backgroundColor: Colors.white,
			type: BottomNavigationBarType.fixed,
			items: <BottomNavigationBarItem>[
				BottomNavigationBarItem(
					icon: Icon(FontAwesomeIcons.compass, size: ScreenUtil().setSp(22), ),
					title: Text(tr.translate("home")),
				),
				BottomNavigationBarItem(
					icon: Icon(FontAwesomeIcons.mapMarkedAlt, size: ScreenUtil().setSp(22),),
					title: Text(tr.translate("map")),
				),
				BottomNavigationBarItem(
					icon: GestureDetector(onTap: scanQR, child: Icon(DBServiceUser.userF.inOrder == null? Icons.camera : FontAwesomeIcons.shoppingCart, size: ScreenUtil().setSp(22),)),
					title: GestureDetector(onTap: scanQR, child: Text("Order")),
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
			currentIndex: CommonData.selectedIndex,
			selectedItemColor: Color.fromRGBO(255, 110, 117, 0.61),
			unselectedItemColor: Color.fromRGBO(130, 130, 130, 1),
			onTap: onItemTapped,
		);
	}

	@override
	Future<bool> didPopRoute() async {
		if(CommonData.selectedIndex == 0) {
			MinimizeApp.minimizeApp();
		}
		else {
			setState(() {
				CommonData.selectedIndex = 0;
			});
			return Future<bool>.value(true);
		}
	}

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_controller.addListener(() {setState(() {
		});});
		_update();
		_timer();
	}

	@override
  Widget build(BuildContext context) {
	  user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
		PushNotificationService.initialise(context);
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
	  if(ready && user != null) {
			return PersistentTabView(
					context,
					controller: _controller,
					screens: [
						MultiProvider(
							providers: [
								Provider<Map<MenuEntry, Restaurant>>(create: (c) => popular,),
								Provider<List<Restaurant>>(create: (c) => nearRestaurants,)
							],
							child: HomeScreen(),
						),
						MapSample(),
						Provider.value(value: _controller, child: OrderScreen()),
						Top(),
						Profile()
					],
					items: [
						PersistentBottomNavBarItem(
							icon: Icon(FontAwesomeIcons.compass, size: ScreenUtil().setSp(22), ),
							title: ("Home"),
							activeColor: selectedItemColor,
							inactiveColor: unselectedItemColor,
						),
						PersistentBottomNavBarItem(
							icon: Icon(FontAwesomeIcons.mapMarkedAlt, size: ScreenUtil().setSp(22),),
							title: ("Map"),
							activeColor: selectedItemColor,
							inactiveColor: unselectedItemColor,
						),
						PersistentBottomNavBarItem(
							icon: Icon(DBServiceUser.userF.inOrder == null? Icons.camera : FontAwesomeIcons.shoppingCart, size: ScreenUtil().setSp(22)),
							title: ("Order"),
							activeColor: selectedItemColor,
							inactiveColor: unselectedItemColor,
						),
						PersistentBottomNavBarItem(
							icon: Icon(Icons.star, size: ScreenUtil().setSp(25),),
							title: ("Top"),
							activeColor: selectedItemColor,
							inactiveColor: unselectedItemColor,
						),
						PersistentBottomNavBarItem(
							icon: Icon(Icons.person, size: ScreenUtil().setSp(25),),
							title: ("Profile"),
							activeColor: selectedItemColor,
							inactiveColor: unselectedItemColor,
						),
					],
					confineInSafeArea: true,
					backgroundColor: Colors.white,
					handleAndroidBackButtonPress: true,
					resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
					stateManagement: true,
					hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
					decoration: NavBarDecoration(
						colorBehindNavBar: Colors.white,
					),
					popAllScreensOnTapOfSelectedTab: true,
					selectedTabScreenContext: (context){
						//PRIMERA VEZ NULL
							CommonData.tabContext = context;
					},
					popActionScreens: PopActionScreensType.all,
					itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
						duration: Duration(milliseconds: 200),
						curve: Curves.ease,
					),
					screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
						animateTabTransition: true,
						curve: Curves.ease,
						duration: Duration(milliseconds: 200),
					),
					navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
					onItemSelected: (num){
						print(CommonData.pop[num]);
						if(CommonData.pop[num] && lastIndex == num){
							CommonData.pop[num] = false;
							Navigator.of(CommonData.tabContext).popUntil((route) {
								return route.settings.name == "/9f580fc5-c252-45d0-af25-9429992db112";
							});
						}
						lastIndex = _controller.index;
					},
			);
			/*return Scaffold(
						body: Stack(
							children: <Widget>[
								Offstage(
									offstage: CommonData.selectedIndex != 0,
									child: TickerMode(
										enabled: CommonData.selectedIndex == 0,
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
									offstage: CommonData.selectedIndex != 1,
									child: TickerMode(
										enabled: CommonData.selectedIndex == 1,
											child: MapSample()
									),
								),
								/*Offstage(
									offstage: _selectedIndex != 2,
									child: TickerMode(
											enabled: _selectedIndex == 2,
											child: QRScanner()
									),
								),*/
								Offstage(
									offstage: CommonData.selectedIndex != 3,
									child: TickerMode(
											enabled: CommonData.selectedIndex == 3,
											child: Top()
									),
								),
								Offstage(
									offstage: CommonData.selectedIndex != 4,
									child: TickerMode(
										enabled: CommonData.selectedIndex == 4,
											child: Profile()
									),
								),

							],
						),
						bottomNavigationBar: getBar()
					);*/

		} else return Loading();
  }
}
