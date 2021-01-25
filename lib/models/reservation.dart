class Reservation{
  String restaurant_id, user_id, table_id, reservationtime, reservationdate;
  int people;

  Reservation({this.restaurant_id, this.people, this.reservationdate, this.reservationtime, this.table_id, this.user_id});
}