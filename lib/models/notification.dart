class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    this.title,
    this.body,
  });
}

class PersonalNotification{
  String user_id, restaurant_id, body, type, id, restaurant_name;
  PersonalNotification({this.body, this.type, this.restaurant_id, this.user_id, this.id, this.restaurant_name});
}