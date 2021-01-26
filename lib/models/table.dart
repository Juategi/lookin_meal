class RestaurantTable{
  String restaurant_id, table_id;
  int amount, capmax, capmin;
  bool edited;
  RestaurantTable({this.restaurant_id, this.amount, this.capmax, this.capmin, this.table_id, this.edited});
}