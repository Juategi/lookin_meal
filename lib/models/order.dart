class Order{
  String order_id, entry_id, note;
  bool send;
  num amount;
  Order({this.order_id, this.amount, this.entry_id, this.send, this.note});
}