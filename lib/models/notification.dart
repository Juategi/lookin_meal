class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    this.title,
    this.body,
  });
}

class Notification{
  String user_id, restaurant_id, body, type, id, restaurant_name;
  Notification({this.body, this.type, this.restaurant_id, this.user_id, this.id, this.restaurant_name});
}