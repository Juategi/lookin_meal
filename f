@startuml
set namespaceSeparator ::

class "lookinmeal::database::entryDB.dart::DBServiceEntry" {
  {static} +DBServiceEntry dbServiceEntry
  +dynamic addMenuEntry()
  +dynamic getMenu()
  +dynamic addSection()
  +dynamic getSections()
  +dynamic getAllRating()
  +dynamic deleteRate()
  +dynamic addRate()
  +dynamic uploadMenu()
  +dynamic updateDailyMenu()
  +dynamic getRatingsHistory()
  +dynamic getEntriesById()
  +dynamic getEntryRatings()
}

"lookinmeal::database::entryDB.dart::DBServiceEntry" o-- "lookinmeal::database::entryDB.dart::DBServiceEntry"

class "lookinmeal::database::paymentDB.dart::DBServicePayment" {
  {static} +DBServicePayment dbServicePayment
  +dynamic getPrices()
  +dynamic getSponsor()
  +dynamic updateSponsor()
  +dynamic createSponsor()
  +dynamic getPremium()
  +dynamic updatePremium()
  +dynamic createPremium()
  +dynamic getPayments()
  +dynamic createPayment()
}

"lookinmeal::database::paymentDB.dart::DBServicePayment" o-- "lookinmeal::database::paymentDB.dart::DBServicePayment"

class "lookinmeal::database::requestDB.dart::DBServiceRequest" {
  {static} +DBServiceRequest dbServiceRequest
  +dynamic sendConfirmationSms()
  +dynamic reSendConfirmationSms()
  +dynamic sendConfirmationCode()
  +dynamic reSendConfirmationCode()
  +dynamic confirmCodes()
  +dynamic createRequest()
  +dynamic createRequestRestaurant()
}

"lookinmeal::database::requestDB.dart::DBServiceRequest" o-- "lookinmeal::database::requestDB.dart::DBServiceRequest"

class "lookinmeal::database::reservationDB.dart::DBServiceReservation" {
  {static} +DBServiceReservation dbServiceReservation
  +dynamic createTable()
  +dynamic getTables()
  +dynamic updateTable()
  +dynamic deleteTable()
  +dynamic createReservation()
  +dynamic getReservationsDay()
  +dynamic getReservationsUser()
  +dynamic deleteReservation()
  +dynamic createCode()
  +dynamic getCodes()
  +dynamic deleteCode()
  +dynamic addExcluded()
  +dynamic getExcluded()
  +dynamic deleteExcluded()
}

"lookinmeal::database::reservationDB.dart::DBServiceReservation" o-- "lookinmeal::database::reservationDB.dart::DBServiceReservation"

class "lookinmeal::database::restaurantDB.dart::DBServiceRestaurant" {
  {static} +DBServiceRestaurant dbServiceRestaurant
  +dynamic deleteFromUserFavorites()
  +dynamic addToUserFavorites()
  +dynamic getUserFavorites()
  +dynamic getRecently()
  +dynamic getOwned()
  +dynamic getRestaurantsById()
  +dynamic getSponsored()
  +dynamic checkRequestStatus()
  +dynamic updateRecently()
  +dynamic getPopular()
  +dynamic getTopEntries()
  +dynamic getTopRestaurants()
  +dynamic getRecommended()
  +dynamic getAllRestaurants()
  +dynamic getNearRestaurants()
  +dynamic getRestaurantsSquare()
  +dynamic uploadRestaurantData()
  +dynamic updateRestaurantData()
  +dynamic updateRestaurantMealTime()
  +dynamic updateRestaurantImages()
  +dynamic getFeed()
  +dynamic parseResponse()
  +dynamic parseResponseEntry()
}

"lookinmeal::database::restaurantDB.dart::DBServiceRestaurant" o-- "lookinmeal::database::restaurantDB.dart::DBServiceRestaurant"

class "lookinmeal::database::statisticDB.dart::DBServiceStatistic" {
  {static} +DBServiceStatistic dbServiceStatistic
  +dynamic getVisits()
  +dynamic addVisit()
  +dynamic getRates()
  +dynamic addRate()
}

"lookinmeal::database::statisticDB.dart::DBServiceStatistic" o-- "lookinmeal::database::statisticDB.dart::DBServiceStatistic"

class "lookinmeal::database::userDB.dart::DBServiceUser" {
  {static} +User userF
  {static} +DBServiceUser dbServiceUser
  +dynamic getUserData()
  +dynamic getUserDataChecker()
  +dynamic getUserDataUsername()
  +dynamic createUser()
  +dynamic checkUsername()
  +dynamic checkUsernameEmail()
  +dynamic updateUserData()
  +dynamic createList()
  +dynamic getLists()
  +dynamic updateList()
  +dynamic deleteList()
  +dynamic createOwner()
  +dynamic getOwners()
  +dynamic deleteOwner()
  +dynamic updateOwner()
  +dynamic addFollower()
  +dynamic deleteFollower()
  +dynamic getNumFollowers()
  +dynamic getNumFollowing()
  +dynamic getFollowers()
  +dynamic getFollowing()
  +dynamic createTicket()
  +dynamic addNotification()
  +dynamic getNotifications()
  +dynamic deleteNotification()
  +dynamic updateToken()
  +dynamic getUsersFeed()
  +dynamic searchUsers()
}

"lookinmeal::database::userDB.dart::DBServiceUser" o-- "lookinmeal::models::user.dart::User"
"lookinmeal::database::userDB.dart::DBServiceUser" o-- "lookinmeal::database::userDB.dart::DBServiceUser"

class "lookinmeal::main.dart::MyApp" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::main.dart::MyApp"

class "lookinmeal::models::code.dart::Code" {
  +String code_id
  +String restaurant_id
  +String link
}

class "lookinmeal::models::dish_query.dart::DishQuery" {
  +String query
  +double price
  +double rating
  +List<String> allergens
}

class "lookinmeal::models::list.dart::FavoriteList" {
  +String name
  +String type
  +String image
  +String id
  +List<String> items
}

class "lookinmeal::models::menu_entry.dart::MenuEntry" {
  +int numReviews
  +int pos
  +dynamic name
  +dynamic section
  +dynamic id
  +dynamic restaurant_id
  +dynamic image
  +dynamic description
  +bool hide
  +double rating
  +double price
  +List allergens
  +double rate
  +int reviews
}

"flutter::src::foundation::change_notifier.dart::ChangeNotifier" <|-- "lookinmeal::models::menu_entry.dart::MenuEntry"

class "lookinmeal::models::notification.dart::PushNotificationMessage" {
  +String title
  +String body
}

class "lookinmeal::models::notification.dart::PersonalNotification" {
  +String user_id
  +String restaurant_id
  +String body
  +String type
  +String id
  +String restaurant_name
}

class "lookinmeal::models::order.dart::Order" {
  +String order_id
  +String entry_id
  +String note
  +bool send
  +bool check
  +num amount
}

class "lookinmeal::models::owner.dart::Owner" {
  +String user_id
  +String restaurant_id
  +String token
  +String type
  +String username
}

class "lookinmeal::models::payment.dart::Payment" {
  +String id
  +String restaurant_id
  +String user_id
  +String paymentdate
  +String service
  +String description
  +double price
}

class "lookinmeal::models::price.dart::Price" {
  +String type
  +int quantity
  +double price
}

class "lookinmeal::models::rating.dart::Rating" {
  +double rating
  +String date
  +String entry_id
  +String comment
}

class "lookinmeal::models::reservation.dart::Reservation" {
  +String restaurant_id
  +String user_id
  +String table_id
  +String reservationtime
  +String reservationdate
  +String username
  +String restaurant_name
  +int people
}

class "lookinmeal::models::restaurant.dart::Restaurant" {
  +String restaurant_id
  +String ta_id
  +String name
  +String phone
  +String website
  +String webUrl
  +String address
  +String email
  +String city
  +String country
  +String currency
  +String premiumtime
  +String subscriptionId
  +String customerId
  +String paymentId
  +double latitude
  +double longitude
  +double rating
  +double distance
  +num mealtime
  +bool premium
  +int numrevta
  +int clicks
  +List<String> types
  +List<String> images
  +List<String> sections
  +List<String> dailymenu
  +List<String> delivery
  +List<String> excludeddays
  +Map<String, List<String>> schedule
  +List<MenuEntry> menu
  +List<Translate> english
  +List<Translate> italian
  +List<Translate> german
  +List<Translate> french
  +List<Translate> spanish
  +List<Translate> original
  +List<RestaurantTable> tables
  +Map<String, List<Reservation>> reservations
  +List<Code> codes
  +DateTime premiumtimetrial
}

class "lookinmeal::models::table.dart::RestaurantTable" {
  +String restaurant_id
  +String table_id
  +int amount
  +int capmax
  +int capmin
  +bool edited
}

class "lookinmeal::models::translate.dart::Translate" {
  +String id
  +String name
  +String description
}

class "lookinmeal::models::user.dart::User" {
  +dynamic name
  +dynamic email
  +dynamic picture
  +dynamic country
  +dynamic username
  +dynamic about
  +dynamic token
  +dynamic uid
  +dynamic service
  +List<Restaurant> favorites
  +List<Restaurant> recently
  +List<Restaurant> owned
  +bool checked
  +List<Rating> ratings
  +List<MenuEntry> favoriteEntry
  +Map<dynamic, Restaurant> history
  +List<FavoriteList> lists
  +List<Reservation> reservations
  +dynamic inOrder
  +int numFollowers
  +int numFollowing
  +List followers
  +List following
  +List<PersonalNotification> notifications
  +List<Restaurant> recent
}

"flutter::src::foundation::change_notifier.dart::ChangeNotifier" <|-- "lookinmeal::models::user.dart::User"

class "lookinmeal::screens::authenticate::authenticate.dart::Authenticate" {
  +_AuthenticateState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::authenticate::authenticate.dart::Authenticate"

class "lookinmeal::screens::authenticate::authenticate.dart::_AuthenticateState" {
  -AuthService _auth
  +Widget build()
}

"lookinmeal::screens::authenticate::authenticate.dart::_AuthenticateState" o-- "lookinmeal::services::auth.dart::AuthService"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::authenticate::authenticate.dart::_AuthenticateState"

class "lookinmeal::screens::authenticate::email_pass.dart::EmailPassword" {
  +_EmailPasswordState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::authenticate::email_pass.dart::EmailPassword"

class "lookinmeal::screens::authenticate::email_pass.dart::_EmailPasswordState" {
  +User user
  -GlobalKey<FormState> _formKey
  +dynamic password
  +dynamic confirmPassword
  +dynamic error
  +bool loading
  +Widget build()
}

"lookinmeal::screens::authenticate::email_pass.dart::_EmailPasswordState" o-- "lookinmeal::models::user.dart::User"
"lookinmeal::screens::authenticate::email_pass.dart::_EmailPasswordState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::authenticate::email_pass.dart::_EmailPasswordState"

class "lookinmeal::screens::authenticate::log_in.dart::LogIn" {
  +_LogInState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::authenticate::log_in.dart::LogIn"

class "lookinmeal::screens::authenticate::log_in.dart::_LogInState" {
  -AuthService _auth
  -GlobalKey<FormState> _formKey
  +dynamic email
  +dynamic password
  +dynamic error
  +Widget build()
}

"lookinmeal::screens::authenticate::log_in.dart::_LogInState" o-- "lookinmeal::services::auth.dart::AuthService"
"lookinmeal::screens::authenticate::log_in.dart::_LogInState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::authenticate::log_in.dart::_LogInState"

class "lookinmeal::screens::authenticate::sign_in.dart::SignIn" {
  +_SignInState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::authenticate::sign_in.dart::SignIn"

class "lookinmeal::screens::authenticate::sign_in.dart::_SignInState" {
  -GlobalKey<FormState> _formKey
  +dynamic username
  +dynamic country
  +dynamic name
  +dynamic error
  +bool loading
  +void initState()
  +Widget build()
}

"lookinmeal::screens::authenticate::sign_in.dart::_SignInState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::authenticate::sign_in.dart::_SignInState"

class "lookinmeal::screens::authenticate::wrapper.dart::Wrapper" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::screens::authenticate::wrapper.dart::Wrapper"

class "lookinmeal::screens::home::home.dart::Home" {
  +_HomeState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::home::home.dart::Home"

class "lookinmeal::screens::home::home.dart::_HomeState" {
  -GeolocationService _geolocationService
  +User user
  +dynamic id
  +dynamic locality
  +dynamic country
  +Position myPos
  +List<Restaurant> nearRestaurants
  +List<Restaurant> recommended
  +List<Restaurant> sponsored
  +Map<MenuEntry, Restaurant> popular
  +List<double> distances
  +int lastIndex
  +Color selectedItemColor
  +Color unselectedItemColor
  -PersistentTabController _controller
  +void onItemTapped()
  -dynamic _getPrices()
  -dynamic _getData()
  -void _update()
  +dynamic initDynamicLinks()
  +dynamic didPopRoute()
  +void initState()
  +Widget build()
}

"lookinmeal::screens::home::home.dart::_HomeState" o-- "lookinmeal::services::geolocation.dart::GeolocationService"
"lookinmeal::screens::home::home.dart::_HomeState" o-- "lookinmeal::models::user.dart::User"
"lookinmeal::screens::home::home.dart::_HomeState" o-- "geolocator_platform_interface::src::models::position.dart::Position"
"lookinmeal::screens::home::home.dart::_HomeState" o-- "dart::ui::Color"
"lookinmeal::screens::home::home.dart::_HomeState" o-- "persistent_bottom_nav_bar::persistent-tab-view.dart::PersistentTabController"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::home::home.dart::_HomeState"
"flutter::src::widgets::binding.dart::WidgetsBindingObserver" <|-- "lookinmeal::screens::home::home.dart::_HomeState"

class "lookinmeal::screens::home::home_screen.dart::HomeScreen" {
  +_HomeScreenState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::home::home_screen.dart::HomeScreen"

class "lookinmeal::screens::home::home_screen.dart::_HomeScreenState" {
  +AppLocalizations tr
  +User user
  +List<Restaurant> nearRestaurants
  +List<Restaurant> recommended
  +List<Restaurant> sponsored
  +Map<MenuEntry, Restaurant> popular
  +dynamic location
  +dynamic code
  +bool first
  +bool search
  +dynamic getCode()
  +bool myInterceptor()
  +void initRating()
  +void initState()
  +void dispose()
  +Widget build()
}

"lookinmeal::screens::home::home_screen.dart::_HomeScreenState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"lookinmeal::screens::home::home_screen.dart::_HomeScreenState" o-- "lookinmeal::models::user.dart::User"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::home::home_screen.dart::_HomeScreenState"

class "lookinmeal::screens::map::map.dart::MapSample" {
  +State createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::map::map.dart::MapSample"

class "lookinmeal::screens::map::map.dart::MapSampleState" {
  +User user
  +Position pos
  +int size
  +double latTo
  +double latFrom
  +double longTo
  +double longFrom
  +bool loading
  +bool first
  +Restaurant selected
  -dynamic _mapStyle
  -Completer<GoogleMapController> _controller
  -GeolocationService _geolocationService
  -GlobalKey<State<StatefulWidget>> _key
  +Map<dynamic, BitmapDescriptor> pinLocationIcons
  +BitmapDescriptor basic
  -List<Restaurant> _restaurants
  -CameraPosition _cameraPosition
  +List<Marker> googleMarkers
  -List<Marker> _markersNoCluster
  +int calculateMarkerSize()
  +dynamic getBytesFromAsset()
  +dynamic updateMarkersSize()
  +void initState()
  -void _getUserLocation()
  -dynamic _loadMarkersNoCluster()
  +Widget build()
}

"lookinmeal::screens::map::map.dart::MapSampleState" o-- "lookinmeal::models::user.dart::User"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "geolocator_platform_interface::src::models::position.dart::Position"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "dart::async::Completer<GoogleMapController>"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "lookinmeal::services::geolocation.dart::GeolocationService"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "flutter::src::widgets::framework.dart::GlobalKey<State<StatefulWidget>>"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "google_maps_flutter_platform_interface::src::types::bitmap.dart::BitmapDescriptor"
"lookinmeal::screens::map::map.dart::MapSampleState" o-- "google_maps_flutter_platform_interface::src::types::camera.dart::CameraPosition"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::map::map.dart::MapSampleState"

class "lookinmeal::screens::profile::check_profile.dart::CheckProfile" {
  +_CheckProfileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::check_profile.dart::CheckProfile"

class "lookinmeal::screens::profile::check_profile.dart::_CheckProfileState" {
  +User user
  +bool init
  +dynamic loadInfo()
  +Widget build()
}

"lookinmeal::screens::profile::check_profile.dart::_CheckProfileState" o-- "lookinmeal::models::user.dart::User"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::check_profile.dart::_CheckProfileState"

class "lookinmeal::screens::profile::edit_profile.dart::EditProfile" {
  +_EditProfileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::edit_profile.dart::EditProfile"

class "lookinmeal::screens::profile::edit_profile.dart::_EditProfileState" {
  -GlobalKey<FormState> _formKey
  -StorageService _storageService
  +dynamic country
  +dynamic image
  +dynamic username
  +dynamic name
  +dynamic about
  +dynamic error
  +bool init
  +Widget build()
}

"lookinmeal::screens::profile::edit_profile.dart::_EditProfileState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"lookinmeal::screens::profile::edit_profile.dart::_EditProfileState" o-- "lookinmeal::services::storage.dart::StorageService"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::edit_profile.dart::_EditProfileState"

class "lookinmeal::screens::profile::favorites.dart::Favorites" {
  +_FavoritesState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::favorites.dart::Favorites"

class "lookinmeal::screens::profile::favorites.dart::_FavoritesState" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::favorites.dart::_FavoritesState"

class "lookinmeal::screens::profile::favorites.dart::FavoriteLists" {
  +_FavoriteListsState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::favorites.dart::FavoriteLists"

class "lookinmeal::screens::profile::favorites.dart::_FavoriteListsState" {
  +dynamic type
  +User user
  +AppLocalizations tr
  -List _loadLists()
  +Widget build()
}

"lookinmeal::screens::profile::favorites.dart::_FavoriteListsState" o-- "lookinmeal::models::user.dart::User"
"lookinmeal::screens::profile::favorites.dart::_FavoriteListsState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::favorites.dart::_FavoriteListsState"

class "lookinmeal::screens::profile::favorites.dart::CreateList" {
  +_CreateListState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::favorites.dart::CreateList"

class "lookinmeal::screens::profile::favorites.dart::_CreateListState" {
  -Icon _icon
  +dynamic iconImage
  +dynamic type
  +dynamic name
  +Widget build()
}

"lookinmeal::screens::profile::favorites.dart::_CreateListState" o-- "flutter::src::widgets::icon.dart::Icon"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::favorites.dart::_CreateListState"

class "lookinmeal::screens::profile::favorites.dart::ListDisplay" {
  +_ListDisplayState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::favorites.dart::ListDisplay"

class "lookinmeal::screens::profile::favorites.dart::_ListDisplayState" {
  +dynamic type
  +dynamic id
  +List<Restaurant> restaurants
  +Map<dynamic, Restaurant> entries
  +FavoriteList list
  +bool init
  +User user
  -void _updateLists()
  +Widget build()
}

"lookinmeal::screens::profile::favorites.dart::_ListDisplayState" o-- "lookinmeal::models::list.dart::FavoriteList"
"lookinmeal::screens::profile::favorites.dart::_ListDisplayState" o-- "lookinmeal::models::user.dart::User"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::favorites.dart::_ListDisplayState"

class "lookinmeal::screens::profile::my_notifications.dart::UserNotifications" {
  +_UserNotificationsState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::my_notifications.dart::UserNotifications"

class "lookinmeal::screens::profile::my_notifications.dart::_UserNotificationsState" {
  -dynamic _getNotifications()
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::my_notifications.dart::_UserNotificationsState"

class "lookinmeal::screens::profile::my_reservations.dart::UserReservations" {
  +_UserReservationsState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::my_reservations.dart::UserReservations"

class "lookinmeal::screens::profile::my_reservations.dart::_UserReservationsState" {
  -dynamic _getReservations()
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::my_reservations.dart::_UserReservationsState"

class "lookinmeal::screens::profile::profile.dart::Profile" {
  +_ProfileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::profile.dart::Profile"

class "lookinmeal::screens::profile::profile.dart::_ProfileState" {
  -AuthService _auth
  +bool first
  -dynamic _getData()
  +Widget build()
}

"lookinmeal::screens::profile::profile.dart::_ProfileState" o-- "lookinmeal::services::auth.dart::AuthService"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::profile.dart::_ProfileState"

class "lookinmeal::screens::profile::propietary::create_restaurant.dart::CreateRestaurant" {
  +_CreateRestaurantState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::propietary::create_restaurant.dart::CreateRestaurant"

class "lookinmeal::screens::profile::propietary::create_restaurant.dart::_CreateRestaurantState" {
  +dynamic relation
  +dynamic currency
  +dynamic error
  +dynamic code
  +dynamic name
  +dynamic website
  +dynamic phone
  +dynamic address
  +dynamic city
  +dynamic country
  +dynamic image
  +dynamic email
  +List types
  +double latitude
  +double longitude
  +bool sent
  -StorageService _storageService
  -GlobalKey<FormState> _formKey
  +AppLocalizations tr
  +dynamic getCode()
  +void initState()
  +Widget build()
}

"lookinmeal::screens::profile::propietary::create_restaurant.dart::_CreateRestaurantState" o-- "lookinmeal::services::storage.dart::StorageService"
"lookinmeal::screens::profile::propietary::create_restaurant.dart::_CreateRestaurantState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"lookinmeal::screens::profile::propietary::create_restaurant.dart::_CreateRestaurantState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::propietary::create_restaurant.dart::_CreateRestaurantState"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::FindRestaurant" {
  +_FindRestaurantState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::FindRestaurant"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::_FindRestaurantState" {
  +bool isSearching
  +dynamic error
  +dynamic query
  +List<Restaurant> results
  -dynamic _search()
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::_FindRestaurantState"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::ConfirmationMenu" {
  +_ConfirmationMenuState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::ConfirmationMenu"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::_ConfirmationMenuState" {
  +Restaurant restaurant
  +Widget build()
}

"lookinmeal::screens::profile::propietary::find_restaurant.dart::_ConfirmationMenuState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::_ConfirmationMenuState"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::ConfirmationCode" {
  +_ConfirmationCodeState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::ConfirmationCode"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::_ConfirmationCodeState" {
  +Restaurant restaurant
  +bool init
  +bool sent
  +int localcode
  +int code
  +dynamic mode
  +dynamic relation
  +Widget build()
}

"lookinmeal::screens::profile::propietary::find_restaurant.dart::_ConfirmationCodeState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::_ConfirmationCodeState"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::IdRequest" {
  +_IdRequestState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::IdRequest"

class "lookinmeal::screens::profile::propietary::find_restaurant.dart::_IdRequestState" {
  +Restaurant restaurant
  +bool init
  +bool sent
  +dynamic idfront
  +dynamic idback
  +dynamic relation
  -StorageService _storageService
  +Widget build()
}

"lookinmeal::screens::profile::propietary::find_restaurant.dart::_IdRequestState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::profile::propietary::find_restaurant.dart::_IdRequestState" o-- "lookinmeal::services::storage.dart::StorageService"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::propietary::find_restaurant.dart::_IdRequestState"

class "lookinmeal::screens::profile::propietary::propietary.dart::OwnerMenu" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::screens::profile::propietary::propietary.dart::OwnerMenu"

class "lookinmeal::screens::profile::propietary::propietary.dart::Owned" {
  +_OwnedState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::propietary::propietary.dart::Owned"

class "lookinmeal::screens::profile::propietary::propietary.dart::_OwnedState" {
  +dynamic loadOwned()
  +void initState()
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::propietary::propietary.dart::_OwnedState"

class "lookinmeal::screens::profile::propietary::propietary.dart::RegisterRestaurantMenu" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::screens::profile::propietary::propietary.dart::RegisterRestaurantMenu"

class "lookinmeal::screens::profile::ratings_tile.dart::RatingTile" {
  +_RatingTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::ratings_tile.dart::RatingTile"

class "lookinmeal::screens::profile::ratings_tile.dart::_RatingTileState" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::ratings_tile.dart::_RatingTileState"

class "lookinmeal::screens::profile::rating_history.dart::RatingHistory" {
  +_RatingHistoryState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::rating_history.dart::RatingHistory"

class "lookinmeal::screens::profile::rating_history.dart::_RatingHistoryState" {
  +AppLocalizations tr
  +bool loading
  +bool init
  +int offset
  +int limit
  +User user
  -void _update()
  +List getListItems()
  +Widget build()
}

"lookinmeal::screens::profile::rating_history.dart::_RatingHistoryState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"lookinmeal::screens::profile::rating_history.dart::_RatingHistoryState" o-- "lookinmeal::models::user.dart::User"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::rating_history.dart::_RatingHistoryState"

class "lookinmeal::screens::profile::support.dart::SupportMenu" {
  +_SupportMenuState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::support.dart::SupportMenu"

class "lookinmeal::screens::profile::support.dart::_SupportMenuState" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::support.dart::_SupportMenuState"

class "lookinmeal::screens::profile::support.dart::TicketMenu" {
  +_TicketMenuState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::support.dart::TicketMenu"

class "lookinmeal::screens::profile::support.dart::_TicketMenuState" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::support.dart::_TicketMenuState"

class "lookinmeal::screens::profile::support.dart::SendTicket" {
  +_SendTicketState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::profile::support.dart::SendTicket"

class "lookinmeal::screens::profile::support.dart::_SendTicketState" {
  +dynamic type
  +dynamic ticket
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::profile::support.dart::_SendTicketState"

class "lookinmeal::screens::restaurants::admin::admin.dart::AdminPage" {
  +_AdminPageState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::admin.dart::AdminPage"

class "lookinmeal::screens::restaurants::admin::admin.dart::_AdminPageState" {
  +Restaurant restaurant
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::admin.dart::_AdminPageState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::admin.dart::_AdminPageState"

class "lookinmeal::screens::restaurants::admin::edit_codes.dart::EditCodes" {
  +_EditCodesState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_codes.dart::EditCodes"

class "lookinmeal::screens::restaurants::admin::edit_codes.dart::_EditCodesState" {
  +Restaurant restaurant
  +bool init
  -dynamic _getCodes()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_codes.dart::_EditCodesState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_codes.dart::_EditCodesState"

class "lookinmeal::screens::restaurants::admin::edit_codes.dart::NewQRCode" {
  +_NewQRCodeState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_codes.dart::NewQRCode"

class "lookinmeal::screens::restaurants::admin::edit_codes.dart::_NewQRCodeState" {
  +Restaurant restaurant
  +dynamic name
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_codes.dart::_NewQRCodeState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_codes.dart::_NewQRCodeState"

class "lookinmeal::screens::restaurants::admin::edit_daily.dart::EditDaily" {
  +_EditDailyState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_daily.dart::EditDaily"

class "lookinmeal::screens::restaurants::admin::edit_daily.dart::_EditDailyState" {
  +Restaurant restaurant
  +List dailyMenu
  +dynamic description
  +double price
  +bool init
  +AppLocalizations tr
  -void _copyMenu()
  -List _initList()
  -bool _isNumeric()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_daily.dart::_EditDailyState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::admin::edit_daily.dart::_EditDailyState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_daily.dart::_EditDailyState"

class "lookinmeal::screens::restaurants::admin::edit_daily.dart::SearchDishDaily" {
  +_SearchDishDailyState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_daily.dart::SearchDishDaily"

class "lookinmeal::screens::restaurants::admin::edit_daily.dart::_SearchDishDailyState" {
  +Restaurant restaurant
  +int i
  +List dailyMenu
  +List<MenuEntry> search
  +bool init
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_daily.dart::_SearchDishDailyState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_daily.dart::_SearchDishDailyState"

class "lookinmeal::screens::restaurants::admin::edit_images.dart::EditImages" {
  +Restaurant restaurant
  +_EditImagesState createState()
}

"lookinmeal::screens::restaurants::admin::edit_images.dart::EditImages" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_images.dart::EditImages"

class "lookinmeal::screens::restaurants::admin::edit_images.dart::_EditImagesState" {
  +Restaurant restaurant
  +List images
  +bool loading
  +void initState()
  -List _initItems()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_images.dart::_EditImagesState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_images.dart::_EditImagesState"

class "lookinmeal::screens::restaurants::admin::edit_menu.dart::EditMenu" {
  +_EditMenuState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_menu.dart::EditMenu"

class "lookinmeal::screens::restaurants::admin::edit_menu.dart::_EditMenuState" {
  +List<MenuEntry> menu
  +List sections
  +List<int> ids
  +Restaurant restaurant
  +bool init
  +bool indicator
  -ScrollController _scrollController
  -StorageService _storageService
  +AppLocalizations tr
  -void _copyLists()
  -List _initMenu()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_menu.dart::_EditMenuState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::admin::edit_menu.dart::_EditMenuState" o-- "flutter::src::widgets::scroll_controller.dart::ScrollController"
"lookinmeal::screens::restaurants::admin::edit_menu.dart::_EditMenuState" o-- "lookinmeal::services::storage.dart::StorageService"
"lookinmeal::screens::restaurants::admin::edit_menu.dart::_EditMenuState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_menu.dart::_EditMenuState"

class "lookinmeal::screens::restaurants::admin::edit_order.dart::EditOrder" {
  +_EditOrderState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_order.dart::EditOrder"

class "lookinmeal::screens::restaurants::admin::edit_order.dart::_EditOrderState" {
  +List<MenuEntry> menu
  +List<MenuEntry> originalMenu
  +List sections
  +List originalSections
  +bool init
  +List<Widget> elements
  +AppLocalizations tr
  -void _copyLists()
  -List _init()
  -void _onReorder()
  -dynamic _keyToString()
  -void _sortMenuPos()
  -MenuEntry _fromKeyToMenuIndex()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_order.dart::_EditOrderState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_order.dart::_EditOrderState"

class "lookinmeal::screens::restaurants::admin::edit_restaurant.dart::EditRestaurant" {
  +_EditRestaurantState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_restaurant.dart::EditRestaurant"

class "lookinmeal::screens::restaurants::admin::edit_restaurant.dart::_EditRestaurantState" {
  -GlobalKey<FormState> _formKey
  +dynamic name
  +dynamic address
  +dynamic phone
  +dynamic email
  +dynamic web
  +dynamic currency
  +List types
  +List delivery
  +Map<dynamic, List> schedule
  +Restaurant restaurant
  +bool loading
  +bool init
  +List<List<Widget>> scheduleTree
  +void initState()
  +Widget build()
  -List _initRow()
}

"lookinmeal::screens::restaurants::admin::edit_restaurant.dart::_EditRestaurantState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"lookinmeal::screens::restaurants::admin::edit_restaurant.dart::_EditRestaurantState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_restaurant.dart::_EditRestaurantState"

class "lookinmeal::screens::restaurants::admin::edit_tables.dart::EditTables" {
  +_EditTablesState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::edit_tables.dart::EditTables"

class "lookinmeal::screens::restaurants::admin::edit_tables.dart::_EditTablesState" {
  +Restaurant restaurant
  +bool myInterceptor()
  -dynamic _updateTables()
  -dynamic _getTables()
  +void initState()
  +void dispose()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::edit_tables.dart::_EditTablesState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::edit_tables.dart::_EditTablesState"

class "lookinmeal::screens::restaurants::admin::manage_admins.dart::ManageAdmins" {
  +_ManageAdminsState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::manage_admins.dart::ManageAdmins"

class "lookinmeal::screens::restaurants::admin::manage_admins.dart::_ManageAdminsState" {
  +List<Owner> owners
  +Restaurant restaurant
  +bool init
  +dynamic loadUsers()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::manage_admins.dart::_ManageAdminsState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::manage_admins.dart::_ManageAdminsState"

class "lookinmeal::screens::restaurants::admin::manage_orders.dart::ManageOrders" {
  +_ManageOrdersState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::manage_orders.dart::ManageOrders"

class "lookinmeal::screens::restaurants::admin::manage_orders.dart::_ManageOrdersState" {
  +Restaurant restaurant
  +RealTimeOrders controller
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::manage_orders.dart::_ManageOrdersState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::admin::manage_orders.dart::_ManageOrdersState" o-- "lookinmeal::services::realtime_orders.dart::RealTimeOrders"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::manage_orders.dart::_ManageOrdersState"

class "lookinmeal::screens::restaurants::admin::manage_orders.dart::OrderDetail" {
  +_OrderDetailState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::manage_orders.dart::OrderDetail"

class "lookinmeal::screens::restaurants::admin::manage_orders.dart::_OrderDetailState" {
  +Restaurant restaurant
  +dynamic code_id
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::manage_orders.dart::_OrderDetailState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::manage_orders.dart::_OrderDetailState"

class "lookinmeal::screens::restaurants::admin::payments.dart::PaymentList" {
  +_PaymentListState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::payments.dart::PaymentList"

class "lookinmeal::screens::restaurants::admin::payments.dart::_PaymentListState" {
  +Restaurant restaurant
  +List<Payment> payments
  +dynamic getPayments()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::payments.dart::_PaymentListState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::payments.dart::_PaymentListState"

class "lookinmeal::screens::restaurants::admin::premium.dart::Premium" {
  +_PremiumState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::premium.dart::Premium"

class "lookinmeal::screens::restaurants::admin::premium.dart::_PremiumState" {
  +Restaurant restaurant
  +bool loading
  +bool card
  +bool cvvFocus
  +bool init
  +dynamic cardName
  +dynamic cardNumber
  +dynamic cvv
  +dynamic date
  +GlobalKey<FormState> formKey
  +dynamic pay()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::premium.dart::_PremiumState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::admin::premium.dart::_PremiumState" o-- "flutter::src::widgets::framework.dart::GlobalKey<FormState>"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::premium.dart::_PremiumState"

class "lookinmeal::screens::restaurants::admin::sponsor.dart::Sponsor" {
  +_SponsorState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::sponsor.dart::Sponsor"

class "lookinmeal::screens::restaurants::admin::sponsor.dart::_SponsorState" {
  +Price actual
  +Restaurant restaurant
  -StreamSubscription<List<PurchaseDetails>> _subscription
  +AppLocalizations tr
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::sponsor.dart::_SponsorState" o-- "lookinmeal::models::price.dart::Price"
"lookinmeal::screens::restaurants::admin::sponsor.dart::_SponsorState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::admin::sponsor.dart::_SponsorState" o-- "dart::async::StreamSubscription<List<PurchaseDetails>>"
"lookinmeal::screens::restaurants::admin::sponsor.dart::_SponsorState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::sponsor.dart::_SponsorState"

class "lookinmeal::screens::restaurants::admin::statistics.dart::Statistics" {
  +_StatisticsState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::admin::statistics.dart::Statistics"

class "lookinmeal::screens::restaurants::admin::statistics.dart::_StatisticsState" {
  +Map<dynamic, int> visits
  +Map<dynamic, int> rates
  +Restaurant restaurant
  +Map<dynamic, int> typesNearly
  +bool init
  -List<bool> _isOpen
  +int yearVisits
  +int yearRates
  +List<int> years
  +List auxVisits
  +List auxRates
  -void _reloadData()
  -dynamic _loadStats()
  +Widget build()
}

"lookinmeal::screens::restaurants::admin::statistics.dart::_StatisticsState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::admin::statistics.dart::_StatisticsState"

class "lookinmeal::screens::restaurants::comments.dart::Comments" {
  +_CommentsState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::comments.dart::Comments"

class "lookinmeal::screens::restaurants::comments.dart::_CommentsState" {
  +MenuEntry entry
  +Map<Rating, User> ratings
  +bool init
  -dynamic _update()
  +Widget build()
}

"lookinmeal::screens::restaurants::comments.dart::_CommentsState" o-- "lookinmeal::models::menu_entry.dart::MenuEntry"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::comments.dart::_CommentsState"

class "lookinmeal::screens::restaurants::daily.dart::DailyMenu" {
  +Restaurant restaurant
  +dynamic currency
  +_DailyMenuState createState()
}

"lookinmeal::screens::restaurants::daily.dart::DailyMenu" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::daily.dart::DailyMenu"

class "lookinmeal::screens::restaurants::daily.dart::_DailyMenuState" {
  +double rate
  +Restaurant restaurant
  -List _initList()
  +Widget build()
  -bool _isNumeric()
}

"lookinmeal::screens::restaurants::daily.dart::_DailyMenuState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::daily.dart::_DailyMenuState"

class "lookinmeal::screens::restaurants::entry.dart::EntryRating" {
  +_EntryRatingState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::entry.dart::EntryRating"

class "lookinmeal::screens::restaurants::entry.dart::_EntryRatingState" {
  +MenuEntry entry
  +Restaurant restaurant
  +double rate
  +double oldRate
  +bool hasRate
  +bool indicator
  +bool init
  +bool order
  +dynamic amount
  +Rating actual
  +dynamic comment
  +dynamic note
  +DateFormat formatter
  -List _loadItems()
  +Widget build()
}

"lookinmeal::screens::restaurants::entry.dart::_EntryRatingState" o-- "lookinmeal::models::menu_entry.dart::MenuEntry"
"lookinmeal::screens::restaurants::entry.dart::_EntryRatingState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::entry.dart::_EntryRatingState" o-- "lookinmeal::models::rating.dart::Rating"
"lookinmeal::screens::restaurants::entry.dart::_EntryRatingState" o-- "intl::src::intl::date_format.dart::DateFormat"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::entry.dart::_EntryRatingState"

class "lookinmeal::screens::restaurants::gallery.dart::Gallery" {
  +_GalleryState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::gallery.dart::Gallery"

class "lookinmeal::screens::restaurants::gallery.dart::_GalleryState" {
  +Restaurant restaurant
  +Widget build()
}

"lookinmeal::screens::restaurants::gallery.dart::_GalleryState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::gallery.dart::_GalleryState"

class "lookinmeal::screens::restaurants::info.dart::RestaurantInfo" {
  +_RestaurantInfoState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::info.dart::RestaurantInfo"

class "lookinmeal::screens::restaurants::info.dart::_RestaurantInfoState" {
  +Restaurant restaurant
  +dynamic code
  +dynamic getCode()
  +void initState()
  +Widget build()
}

"lookinmeal::screens::restaurants::info.dart::_RestaurantInfoState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::info.dart::_RestaurantInfoState"

class "lookinmeal::screens::restaurants::main_screen_dish_tile.dart::DishTile" {
  +_DishTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::main_screen_dish_tile.dart::DishTile"

class "lookinmeal::screens::restaurants::main_screen_dish_tile.dart::_DishTileState" {
  +MenuEntry entry
  +User user
  +Restaurant restaurant
  +Widget build()
}

"lookinmeal::screens::restaurants::main_screen_dish_tile.dart::_DishTileState" o-- "lookinmeal::models::menu_entry.dart::MenuEntry"
"lookinmeal::screens::restaurants::main_screen_dish_tile.dart::_DishTileState" o-- "lookinmeal::models::user.dart::User"
"lookinmeal::screens::restaurants::main_screen_dish_tile.dart::_DishTileState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::main_screen_dish_tile.dart::_DishTileState"

class "lookinmeal::screens::restaurants::menu.dart::Menu" {
  +_MenuState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::menu.dart::Menu"

class "lookinmeal::screens::restaurants::menu.dart::_MenuState" {
  +double rate
  +Restaurant restaurant
  +Map<dynamic, bool> expanded
  +bool init
  +bool order
  -List _initList()
  +Widget build()
}

"lookinmeal::screens::restaurants::menu.dart::_MenuState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::menu.dart::_MenuState"

class "lookinmeal::screens::restaurants::menu_tile.dart::MenuTile" {
  +bool daily
  +_MenuTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::menu_tile.dart::MenuTile"

class "lookinmeal::screens::restaurants::menu_tile.dart::_MenuTileState" {
  +MenuEntry entry
  +Restaurant restaurant
  +bool order
  +bool daily
  +Widget build()
}

"lookinmeal::screens::restaurants::menu_tile.dart::_MenuTileState" o-- "lookinmeal::models::menu_entry.dart::MenuEntry"
"lookinmeal::screens::restaurants::menu_tile.dart::_MenuTileState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::menu_tile.dart::_MenuTileState"
"flutter::src::widgets::ticker_provider.dart::TickerProviderStateMixin<T>" <|-- "lookinmeal::screens::restaurants::menu_tile.dart::_MenuTileState"

class "lookinmeal::screens::restaurants::orders::order_screen.dart::OrderScreen" {
  +_OrderScreenState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::orders::order_screen.dart::OrderScreen"

class "lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" {
  +Restaurant restaurant
  +dynamic restaurant_id
  +dynamic table_id
  +dynamic code
  +bool init
  +bool first
  +double bill
  +RealTimeOrders controller
  -PersistentTabController _controller
  +AppLocalizations tr
  +QRViewController qrController
  +GlobalKey<State<StatefulWidget>> qrKey
  -void _onQRViewCreated()
  +void dispose()
  +void reassemble()
  +dynamic getRestaurant()
  -List _loadOrder()
  +dynamic scanQR()
  +Widget build()
}

"lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" o-- "lookinmeal::services::realtime_orders.dart::RealTimeOrders"
"lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" o-- "persistent_bottom_nav_bar::persistent-tab-view.dart::PersistentTabController"
"lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" o-- "qr_code_scanner::src::qr_code_scanner.dart::QRViewController"
"lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState" o-- "flutter::src::widgets::framework.dart::GlobalKey<State<StatefulWidget>>"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState"
"flutter::src::foundation::change_notifier.dart::ChangeNotifier" <|-- "lookinmeal::screens::restaurants::orders::order_screen.dart::_OrderScreenState"

class "lookinmeal::screens::restaurants::orders::order_screen.dart::AddMoreOrder" {
  +_AddMoreOrderState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::orders::order_screen.dart::AddMoreOrder"

class "lookinmeal::screens::restaurants::orders::order_screen.dart::_AddMoreOrderState" {
  +Restaurant restaurant
  +Widget build()
}

"lookinmeal::screens::restaurants::orders::order_screen.dart::_AddMoreOrderState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::orders::order_screen.dart::_AddMoreOrderState"

class "lookinmeal::screens::restaurants::profile_restaurant.dart::ProfileRestaurant" {
  +_ProfileRestaurantState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::profile_restaurant.dart::ProfileRestaurant"

class "lookinmeal::screens::restaurants::profile_restaurant.dart::_ProfileRestaurantState" {
  +Restaurant restaurant
  +bool first
  +bool uploaded
  +bool loading
  +dynamic language
  +List<Owner> owners
  +List<File> photos
  +dynamic requestStatus
  +AppLocalizations tr
  -void _loadOwners()
  -void _loadData()
  -void _loadStatus()
  -List _loadTop()
  -int _lines()
  -List _getTop()
  +dynamic backToOriginal()
  +bool myInterceptor()
  +void initState()
  +void dispose()
  -List _loadItems()
  +Widget build()
}

"lookinmeal::screens::restaurants::profile_restaurant.dart::_ProfileRestaurantState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::restaurants::profile_restaurant.dart::_ProfileRestaurantState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::profile_restaurant.dart::_ProfileRestaurantState"

class "lookinmeal::screens::restaurants::reservations.dart::ReservationsChecker" {
  +_ReservationsCheckerState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::reservations.dart::ReservationsChecker"

class "lookinmeal::screens::restaurants::reservations.dart::_ReservationsCheckerState" {
  +Restaurant restaurant
  +DateTime dateSelected
  +dynamic dateString
  +bool loading
  +bool init
  -dynamic _getReservations()
  +void initState()
  +Widget build()
}

"lookinmeal::screens::restaurants::reservations.dart::_ReservationsCheckerState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::reservations.dart::_ReservationsCheckerState"

class "lookinmeal::screens::restaurants::reserve_table.dart::TableReservation" {
  +_TableReservationState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::reserve_table.dart::TableReservation"

class "lookinmeal::screens::restaurants::reserve_table.dart::_TableReservationState" {
  +Restaurant restaurant
  +int pos
  +int people
  +int minTimeDif
  +int hour
  +DateTime dateSelected
  +Map<int, dynamic> available
  +bool init
  +bool loading
  +bool noSchedule
  +dynamic getExcluded()
  -dynamic _calculateAvailable()
  +Widget build()
}

"lookinmeal::screens::restaurants::reserve_table.dart::_TableReservationState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::reserve_table.dart::_TableReservationState"

class "lookinmeal::screens::restaurants::restaurant_tile.dart::RestaurantTile" {
  +_RestaurantTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::restaurant_tile.dart::RestaurantTile"

class "lookinmeal::screens::restaurants::restaurant_tile.dart::_RestaurantTileState" {
  +Restaurant restaurant
  +bool sponsored
  +Widget build()
}

"lookinmeal::screens::restaurants::restaurant_tile.dart::_RestaurantTileState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::restaurant_tile.dart::_RestaurantTileState"

class "lookinmeal::screens::restaurants::top_dishes_tile.dart::TopDishesTile" {
  +_TopDishesTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::restaurants::top_dishes_tile.dart::TopDishesTile"

class "lookinmeal::screens::restaurants::top_dishes_tile.dart::_TopDishesTileState" {
  +MenuEntry entry
  +Restaurant restaurant
  +Widget build()
}

"lookinmeal::screens::restaurants::top_dishes_tile.dart::_TopDishesTileState" o-- "lookinmeal::models::menu_entry.dart::MenuEntry"
"lookinmeal::screens::restaurants::top_dishes_tile.dart::_TopDishesTileState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::restaurants::top_dishes_tile.dart::_TopDishesTileState"
"flutter::src::widgets::ticker_provider.dart::TickerProviderStateMixin<T>" <|-- "lookinmeal::screens::restaurants::top_dishes_tile.dart::_TopDishesTileState"

class "lookinmeal::screens::search::search.dart::Search" {
  +_SearchState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::search::search.dart::Search"

class "lookinmeal::screens::search::search.dart::_SearchState" {
  +Map<MenuEntry, Restaurant> map
  +AppLocalizations tr
  +bool isRestaurant
  +bool isSearching
  +bool searching
  +bool searchingMore
  +dynamic searchType
  +dynamic locality
  +List<DishQuery> queries
  +List types
  +DishQuery actual
  +dynamic error
  +dynamic query
  +double maxDistance
  +int offset
  +List<Restaurant> result
  +List<Restaurant> sponsored
  +Map<Restaurant, List> resultEntry
  -dynamic _search()
  -dynamic _searchMore()
  -Widget _buildList()
  +void initState()
  +Widget build()
}

"lookinmeal::screens::search::search.dart::_SearchState" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"
"lookinmeal::screens::search::search.dart::_SearchState" o-- "lookinmeal::models::dish_query.dart::DishQuery"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::search::search.dart::_SearchState"

class "lookinmeal::screens::search::searchTiles.dart::SearchRestaurantTile" {
  +_SearchRestaurantTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::search::searchTiles.dart::SearchRestaurantTile"

class "lookinmeal::screens::search::searchTiles.dart::_SearchRestaurantTileState" {
  +Restaurant restaurant
  +List<MenuEntry> top
  +bool init
  +bool sponsored
  -List _getTop()
  +Widget build()
}

"lookinmeal::screens::search::searchTiles.dart::_SearchRestaurantTileState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::search::searchTiles.dart::_SearchRestaurantTileState"

class "lookinmeal::screens::search::searchTiles.dart::SearchEntryTile" {
  +_SearchEntryTileState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::search::searchTiles.dart::SearchEntryTile"

class "lookinmeal::screens::search::searchTiles.dart::_SearchEntryTileState" {
  +Restaurant restaurant
  +MenuEntry entry
  +Widget build()
}

"lookinmeal::screens::search::searchTiles.dart::_SearchEntryTileState" o-- "lookinmeal::models::restaurant.dart::Restaurant"
"lookinmeal::screens::search::searchTiles.dart::_SearchEntryTileState" o-- "lookinmeal::models::menu_entry.dart::MenuEntry"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::search::searchTiles.dart::_SearchEntryTileState"

class "lookinmeal::screens::social::social.dart::SocialScreen" {
  +_SocialScreenState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::social::social.dart::SocialScreen"

class "lookinmeal::screens::social::social.dart::_SocialScreenState" {
  +List<List> feed
  +dynamic query
  +List<User> usersFeed
  +List<User> usersSearch
  +bool init
  +bool done
  +int offset
  -dynamic _searchUsers()
  -dynamic _loadUsers()
  -dynamic _loadFeed()
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::social::social.dart::_SocialScreenState"

class "lookinmeal::screens::top::top.dart::Top" {
  +_TopState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::screens::top::top.dart::Top"

class "lookinmeal::screens::top::top.dart::_TopState" {
  +List<Restaurant> topRestaurant
  +List<Restaurant> sponsored
  +Map<MenuEntry, Restaurant> topEntry
  +Position last
  -dynamic _loadData()
  +void initState()
  +Widget build()
}

"lookinmeal::screens::top::top.dart::_TopState" o-- "geolocator_platform_interface::src::models::position.dart::Position"
"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::screens::top::top.dart::_TopState"

class "lookinmeal::services::app_localizations.dart::AppLocalizations" {
  +Locale locale
  {static} +LocalizationsDelegate<AppLocalizations> delegate
  -Map _localizedStrings
  {static} +AppLocalizations of()
  +dynamic load()
  +dynamic translate()
}

"lookinmeal::services::app_localizations.dart::AppLocalizations" o-- "dart::ui::Locale"
"lookinmeal::services::app_localizations.dart::AppLocalizations" o-- "flutter::src::widgets::localizations.dart::LocalizationsDelegate<AppLocalizations>"

class "lookinmeal::services::app_localizations.dart::_AppLocalizationsDelegate" {
  +bool isSupported()
  +dynamic load()
  +bool shouldReload()
}

"flutter::src::widgets::localizations.dart::LocalizationsDelegate<T>" <|-- "lookinmeal::services::app_localizations.dart::_AppLocalizationsDelegate"

class "lookinmeal::services::auth.dart::AuthService" {
  -FirebaseAuth _auth
  +Stream user
  -User _userFromFirebaseUser()
  +dynamic signInEP()
  +dynamic registerEP()
  +dynamic loginFB()
  +dynamic loginGoogle()
  +void reBirth()
  +dynamic signOut()
}

"lookinmeal::services::auth.dart::AuthService" o-- "firebase_auth::firebase_auth.dart::FirebaseAuth"
"lookinmeal::services::auth.dart::AuthService" o-- "dart::async::Stream"

class "lookinmeal::services::enviroment.dart::Enviroment" {
  {static} +String getApi()
  {static} +dynamic init()
}

class "lookinmeal::services::geolocation.dart::GeolocationService" {
  {static} +String locality
  {static} +String country
  {static} +Position myPos
  +dynamic distanceBetween()
  +dynamic getLocation()
  +dynamic getLocality()
  +dynamic getCountry()
  {static} +dynamic prueba()
}

"lookinmeal::services::geolocation.dart::GeolocationService" o-- "geolocator_platform_interface::src::models::position.dart::Position"

class "lookinmeal::services::payment.dart::InAppPurchasesService" {
  {static} +dynamic initPlatformState()
  +dynamic buyProduct()
  +dynamic createPaymentMethodCard()
  -dynamic _processPaymentAsDirectCharge()
  +dynamic cancelSubscription()
  +dynamic deliverSubscription()
  +dynamic deliverProduct()
}

class "lookinmeal::services::pool.dart::Pool" {
  {static} +List<Restaurant> restaurants
  {static} +Restaurant getRestaurant()
  {static} +void addRestaurant()
}

class "lookinmeal::services::push_notifications.dart::PushNotificationService" {
  {static} +dynamic initialise()
  {static} +dynamic sendNotification()
}

class "lookinmeal::services::realtime_orders.dart::RealTimeOrders" {
  +CollectionReference<Object> orders
  {static} +List<Order> items
  {static} +String actualTable
  {static} +bool sent
  +dynamic createOrder()
  +dynamic deleteOrder()
  +dynamic closeOrder()
  +dynamic openOrder()
  +dynamic createOrderData()
  +dynamic updateOrderData()
  +dynamic deleteOrderData()
  +Stream getOrder()
  +Stream checkClose()
}

"lookinmeal::services::realtime_orders.dart::RealTimeOrders" o-- "cloud_firestore::cloud_firestore.dart::CollectionReference<Object>"

class "lookinmeal::services::scanner.dart::QRScanner" {
  +_QRScannerState createState()
}

"flutter::src::widgets::framework.dart::StatefulWidget" <|-- "lookinmeal::services::scanner.dart::QRScanner"

class "lookinmeal::services::scanner.dart::_QRScannerState" {
  +dynamic scanQR()
  +Widget build()
}

"flutter::src::widgets::framework.dart::State<T>" <|-- "lookinmeal::services::scanner.dart::_QRScannerState"

class "lookinmeal::services::search.dart::SearchService" {
  +dynamic query()
  +dynamic queryEntry()
}

class "lookinmeal::services::storage.dart::StorageService" {
  -Uuid _uuid
  +AppLocalizations tr
  +dynamic uploadImage()
  -dynamic _uploadImage()
  +dynamic removeFile()
  +dynamic uploadNanonets()
  +dynamic sendNanonets()
}

"lookinmeal::services::storage.dart::StorageService" o-- "uuid::uuid.dart::Uuid"
"lookinmeal::services::storage.dart::StorageService" o-- "lookinmeal::services::app_localizations.dart::AppLocalizations"

class "lookinmeal::services::translator.dart::Translator" {
  {static} +dynamic translate()
  {static} +dynamic doTranslation()
}

class "lookinmeal::shared::alert.dart::Alerts" {
  {static} +void dialog()
  {static} +dynamic confirmation()
  {static} +void toast()
}

class "lookinmeal::shared::common_data.dart::CommonData" {
  {static} +int selectedIndex
  {static} +int screenHeight
  {static} +int screenWidth
  {static} +int maxElementsList
  {static} +Map<int, bool> pop
  {static} +dynamic actualCode
  {static} +BuildContext tabContext
  {static} +dynamic defaultProfile
  {static} +List allergens
  {static} +Color backgroundColor
  {static} +List typesList
  {static} +List typesRelation
  {static} +List<Price> prices
  {static} +List types
  {static} +Map typesImage
}

"lookinmeal::shared::common_data.dart::CommonData" o-- "flutter::src::widgets::framework.dart::BuildContext"
"lookinmeal::shared::common_data.dart::CommonData" o-- "dart::ui::Color"

class "lookinmeal::shared::functions.dart::Functions" {
  {static} +int getVotes()
  {static} +double getRating()
  {static} +bool compareList()
  {static} +String limitString()
  {static} +List cleanStrings()
  {static} +List copyList()
  {static} +String formatDate()
  {static} +int compareDates()
  {static} +String parseSchedule()
}

class "lookinmeal::shared::loading.dart::Loading" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::shared::loading.dart::Loading"

class "lookinmeal::shared::loading.dart::CircularLoading" {
  +Widget build()
}

"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::shared::loading.dart::CircularLoading"

class "lookinmeal::shared::strings.dart::StaticStrings" {
  {static} +String defaultImage
  {static} +String defaultEntry
  {static} +String api
  {static} +String nanonets
  {static} +String emailReg
  {static} +int screenHeight
  {static} +int screenWidth
}

class "lookinmeal::shared::widgets.dart::StarRating" {
  +int starCount
  +double rating
  +double size
  +Color color
  +Widget buildStar()
  +Widget build()
}

"lookinmeal::shared::widgets.dart::StarRating" o-- "dart::ui::Color"
"flutter::src::widgets::framework.dart::StatelessWidget" <|-- "lookinmeal::shared::widgets.dart::StarRating"


@enduml