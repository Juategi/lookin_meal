import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/order.dart';
class RealTimeOrders{

  RealTimeOrders();

  final CollectionReference orders = Firestore.instance.collection('orders');
  static List<Order> items;
  static String actualTable;
  static bool sent = false;

  Future createOrder(String restaurant_id, String table_id) async{
    orders.document(restaurant_id).collection(table_id).document("closed").setData({
      "closed" : false
    });
  }

  Future deleteOrder(String restaurant_id, String table_id) async{
    orders.document(restaurant_id).collection(table_id).getDocuments().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
    });
  }

  Future closeOrder(String restaurant_id, String table_id) async{
    await orders.document(restaurant_id).collection(table_id).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        if(ds.documentID != "closed")
          ds.reference.delete();
        else
          ds.reference.setData({'closed' : true});
      }
    });
    openOrder(restaurant_id, table_id);
  }

  Future openOrder(String restaurant_id, String table_id) async{
    orders.document(restaurant_id).collection(table_id).document("closed").setData({'closed' : false});
  }

  Future createOrderData(String restaurant_id, Order order) async {
    DocumentReference ref = orders.document(restaurant_id).collection(actualTable).document();
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
      await ref.setData({
        'amount': order.amount,
        'entry_id': order.entry_id,
        'send': order.send,
        'note': order.note,
         'check': order.check
      });
      order.order_id = ref.documentID;
    }
    //items.add(order);
  }

  Future updateOrderData(String restaurant_id, String table_id, Order order) async {
    DocumentReference ref = orders.document(restaurant_id).collection(table_id).document(order.order_id);
    await ref.setData({
      'amount': order.amount,
      'entry_id': order.entry_id,
      'send': order.send,
      'note' : order.note,
      'check': order.check
    });
  }

  Future deleteOrderData(String restaurant_id, String table_id, Order order) async{
    orders.document(restaurant_id).collection(table_id).document(order.order_id).delete();
  }

  Stream<List<Order>> getOrder(String restaurant_id, String table_id) {
    return orders.document(restaurant_id).collection(table_id).snapshots().map((event) => event.documents.where((element) => element.documentID != "closed").map((s) {
        return Order(
            order_id: s.documentID,
            amount: s.data['amount'],
            entry_id: s.data['entry_id'],
            send: s.data['send'],
           note: s.data['note'],
          check: s.data['check']
        );
    }).toList());
  }

  Stream<bool> checkClose(String restaurant_id, String table_id) {
    if(restaurant_id == ""){
      return null;
    }
    return orders.document(restaurant_id).collection(table_id).document("closed").snapshots().map((s){
      bool closed =  s.data['closed'];
      return closed;
    });
  }

}