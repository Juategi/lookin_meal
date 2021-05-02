import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/order.dart';
class RealTimeOrders{

  RealTimeOrders();

  final CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  static List<Order> items;
  static String actualTable;
  static bool sent = false;

  Future createOrder(String restaurant_id, String table_id) async{
    orders.doc(restaurant_id).collection(table_id).doc("closed").set({
      "closed" : false
    });
  }

  Future deleteOrder(String restaurant_id, String table_id) async{
    (await orders.doc(restaurant_id).collection(table_id).get()).docs.map((doc) {
      doc.reference.delete();
    });
  }

  Future closeOrder(String restaurant_id, String table_id) async{
    (await orders.doc(restaurant_id).collection(table_id).get()).docs.map((doc) {
      if(doc.id != "closed")
        doc.reference.delete();
      else
        doc.reference.set({'closed' : true});
    });
    openOrder(restaurant_id, table_id);
  }

  Future openOrder(String restaurant_id, String table_id) async{
    orders.doc(restaurant_id).collection(table_id).doc("closed").set({'closed' : false});
  }

  Future createOrderData(String restaurant_id, Order order) async {
    DocumentReference ref = orders.doc(restaurant_id).collection(actualTable).doc();
    bool found = false;
    items.where((element) => !element.send).forEach((o) {
      if(o.entry_id == order.entry_id){
        found = true;
        o.amount += order.amount;
        o.note = o.note + " / " + order.note;
        updateOrderData(restaurant_id, actualTable, o);
      }
    });
    if(!found) {
      await ref.set({
        'amount': order.amount,
        'entry_id': order.entry_id,
        'send': order.send,
        'note': order.note,
         'check': order.check
      });
      order.order_id = ref.id;
    }
    //items.add(order);
  }

  Future updateOrderData(String restaurant_id, String table_id, Order order) async {
    DocumentReference ref = orders.doc(restaurant_id).collection(table_id).doc(order.order_id);
    await ref.set({
      'amount': order.amount,
      'entry_id': order.entry_id,
      'send': order.send,
      'note' : order.note,
      'check': order.check
    });
  }

  Future deleteOrderData(String restaurant_id, String table_id, Order order) async{
    orders.doc(restaurant_id).collection(table_id).doc(order.order_id).delete();
  }

  Stream<List<Order>> getOrder(String restaurant_id, String table_id) {
    return orders.doc(restaurant_id).collection(table_id).snapshots().map((event) => event.docs.where((element) => element.id != "closed").map((s) {
        return Order(
            order_id: s.id,
            amount: s.data()['amount'],
            entry_id: s.data()['entry_id'],
            send: s.data()['send'],
           note: s.data()['note'],
          check: s.data()['check']
        );
    }).toList());
  }

  Stream<bool> checkClose(String restaurant_id, String table_id) {
    if(restaurant_id == ""){
      return null;
    }
    return orders.doc(restaurant_id).collection(table_id).doc("closed").snapshots().map((s){
      bool closed =  s.data()['closed'];
      return closed;
    });
  }

}