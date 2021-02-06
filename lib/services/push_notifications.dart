import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:lookinmeal/database/restaurantDB.dart';
import 'package:lookinmeal/models/notification.dart';
import 'package:lookinmeal/models/restaurant.dart';
import 'package:lookinmeal/services/geolocation.dart';
import 'package:lookinmeal/shared/alert.dart';
import 'package:flutter/material.dart';

class PushNotificationService {

  static Future initialise(BuildContext context) async {
    final FirebaseMessaging _fcm = FirebaseMessaging();
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.setAutoInitEnabled(false);

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          PushNotificationMessage notification;
          if (Platform.isAndroid) {
            notification = PushNotificationMessage(
              title: message['notification']['title'],
              body: message['notification']['body'],
            );
          }
          Alerts.confirmation(notification.title + '  ' + notification.body, context);
        },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        List<Restaurant> aux = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById([message['data']['restaurant_id']], GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
        DBServiceRestaurant.dbServiceRestaurant.updateRecently(aux.first);
        Navigator.pushNamed(context, "/restaurant",arguments: aux.first);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        List<Restaurant> aux = await DBServiceRestaurant.dbServiceRestaurant.getRestaurantsById([message['data']['restaurant_id']], GeolocationService.myPos.latitude, GeolocationService.myPos.longitude);
        DBServiceRestaurant.dbServiceRestaurant.updateRecently(aux.first);
        Navigator.pushNamed(context, "/restaurant",arguments: aux.first);
      },
    );
  }

  static Future<Map<String, dynamic>>sendNotification(String title, String body, String restaurant_id, String token) async{
    final String serverToken = 'AAAAuKZsomY:APA91bFrOQ5dK5nZlrPdbXHHIr19OF1yvVKAwve9xNpR9b_bTL3ZLjpnI2JvvGxHcs7pLHqD-RN2i-fWtutB-WYBk_QF7lZ8MjV-EueMKtyT01JLQP-dlxiYYEkSl5u3IsI_-WYC1dGI';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'restaurant_id' : restaurant_id
          },
          'to': token,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

}