import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookinmeal/database/paymentDB.dart';
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/menu_entry.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/models/user.dart';
import 'package:lookinmeal/screens/home/home_screen.dart';
import 'package:lookinmeal/screens/profile/profile.dart';
import 'package:lookinmeal/screens/restaurants/orders/order_screen.dart';
import 'package:lookinmeal/screens/restaurants/profile_restaurant.dart';
import 'package:lookinmeal/screens/social/social.dart';
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
import 'package:rate_my_app/rate_my_app.dart';
import 'package:splashscreen/splashscreen.dart';



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
	List<Restaurant> nearRestaurants, recommended, sponsored;
	Map<MenuEntry,Restaurant> popular;
	List<double> distances = List<double>();
	int lastIndex = 0;
	Color selectedItemColor = Color.fromRGBO(255, 110, 117, 0.61);
	Color unselectedItemColor = Color.fromRGBO(130, 130, 130, 1);
	PersistentTabController _controller = PersistentTabController(initialIndex: 0);

	void onItemTapped(int index) {
		setState(()  {
			CommonData.selectedIndex = index;
		});
	}

	Future _getPrices() async{
		CommonData.prices = await DBServicePayment.dbServicePayment.getPrices();
		CommonData.prices.sort((p1, p2) => p1.quantity.compareTo(p2.quantity));
	}

	Future _getData() async{
		DBServiceUser.userF.notifications = await DBServiceUser.dbServiceUser.getNotifications(DBServiceUser.userF.uid);
		DBServiceUser.userF.numFollowers = await DBServiceUser.dbServiceUser.getNumFollowers(DBServiceUser.userF.uid);
		DBServiceUser.userF.numFollowing = await DBServiceUser.dbServiceUser.getNumFollowing(DBServiceUser.userF.uid);
		print("updating...");
	}

	void _update()async{
		myPos = await _geolocationService.getLocation();
		locality = await _geolocationService.getLocality(myPos.latitude, myPos.longitude);
		country = await _geolocationService.getCountry(myPos.latitude, myPos.longitude);
		nearRestaurants= await DBServiceRestaurant.dbServiceRestaurant.getNearRestaurants(myPos.latitude, myPos.longitude, 12);
		sponsored = await DBServiceRestaurant.dbServiceRestaurant.getSponsored(3);
		recommended = await DBServiceRestaurant.dbServiceRestaurant.getRecommended(DBServiceUser.userF.uid);
		/*for(Restaurant restaurant in restaurants){
			distances.add(await _geolocationService.distanceBetween(myPos.latitude,myPos.longitude, restaurant.latitude, restaurant.longitude));
		}*/
		popular = await DBServiceRestaurant.dbServiceRestaurant.getPopular();
		setState(() {
		});
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

	Future<void> initDynamicLinks(BuildContext context) async {
		//https://findeat.page.link/?link=https://findeat.page.link/restaurant?id=833&apn=com.wt.lookinmeal
		//https://findeat.page.link/?link=https://findeat.page.link/order?id=833/aa&apn=com.wt.lookinmeal
		FirebaseDynamicLinks.instance.onLink(
				onSuccess: (PendingDynamicLinkData dynamicLink) async {
					final Uri deepLink = dynamicLink.link;
					if (deepLink != null) {
						print(deepLink.queryParameters['id']);
						if(deepLink.path == "/restaurant") {
							Restaurant restaurant = (await DBServiceRestaurant
									.dbServiceRestaurant.getRestaurantsById(
									[deepLink.queryParameters['id']],
									GeolocationService.myPos.latitude,
									GeolocationService.myPos.longitude)).first;
							pushNewScreenWithRouteSettings(
								context,
								settings: RouteSettings(
										name: "/restaurant", arguments: restaurant),
								screen: ProfileRestaurant(),
								withNavBar: true,
								pageTransitionAnimation: PageTransitionAnimation.slideUp,
							);
						}
						else{
							Restaurant restaurant = (await DBServiceRestaurant
									.dbServiceRestaurant.getRestaurantsById(
									[deepLink.queryParameters['id'].split("/").first],
									GeolocationService.myPos.latitude,
									GeolocationService.myPos.longitude)).first;
							await DBServicePayment.dbServicePayment.getPremium(restaurant);
							if(restaurant.premium) {
								CommonData.actualCode = deepLink.queryParameters['id'];
								_controller.jumpToTab(2);
							}
							else{
								pushNewScreenWithRouteSettings(
									context,
									settings: RouteSettings(
											name: "/restaurant", arguments: restaurant),
									screen: ProfileRestaurant(),
									withNavBar: true,
									pageTransitionAnimation: PageTransitionAnimation.slideUp,
								);
							}
						}
					}
				}, onError: (OnLinkErrorException e) async {
			print('onLinkError');
			print(e.message);
		});


		/*

		final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
		final Uri deepLink = data.link;

		if (deepLink != null) {
			// ignore: unawaited_futures
			Navigator.pushNamed(context, deepLink.path);
		}*/
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
		_getPrices();
	}

	@override
  Widget build(BuildContext context) {
	  user = Provider.of<User>(context);
	  AppLocalizations tr = AppLocalizations.of(context);
	  initDynamicLinks(context);
		ScreenUtil.init(context, height: CommonData.screenHeight, width: CommonData.screenWidth, allowFontScaling: true);
	  if(popular != null && user != null) {
			PushNotificationService.initialise(context);
			return PersistentTabView(
					context,
					controller: _controller,
					screens: [
						MultiProvider(
							providers: [
								Provider<Map<MenuEntry, Restaurant>>(create: (c) => popular,),
								Provider<List<List<Restaurant>>>(create: (c) => [nearRestaurants , recommended, sponsored],)
							],
							child: HomeScreen(),
						),
						MapSample(),
						Provider.value(value: _controller, child: OrderScreen()),
						SocialScreen(),
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
							icon: Icon(Icons.people_alt_sharp, size: ScreenUtil().setSp(25),),
							title: ("Social"),
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
						if(num == 4)
							_getData();
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

		} else return SplashScreen(
				seconds: 3,
				//navigateAfterSeconds: Wrapper(),
				title: Text.rich(
					TextSpan(
						children: [
							TextSpan(text: 'Find', style: GoogleFonts.newsCycle(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.normal, fontSize: 72,),),),
							TextSpan(text: 'Eat', style: GoogleFonts.newsCycle(textStyle: TextStyle(color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold, fontSize: 72,),))
						],
					),
				),
				image: Image.asset('assets/logo.png'),
				backgroundColor: Color.fromRGBO(255, 110, 117, 0.9),
				styleTextUnderTheLoader: TextStyle(),
				photoSize: 110.0,
				loaderColor: Colors.white
		);
  }
}
