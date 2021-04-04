class Payment{
  String id, restaurant_id, user_id, paymentdate, service, description;
  double price;
  Payment({this.restaurant_id, this.user_id, this.service, this.price, this.id, this.description, this.paymentdate});
}