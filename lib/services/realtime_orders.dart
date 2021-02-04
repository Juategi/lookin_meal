import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookinmeal/models/order.dart';
class RealTimeOrders{

  RealTimeOrders();

  final CollectionReference orders = Firestore.instance.collection('orders');
  static List<Order> items;

  Future createOrder(String restaurant_id, String order_id) async{
    orders.document(restaurant_id).collection(order_id).document("closed").setData({
      "closed" : false
    });
  }

  Future deleteOrder(String restaurant_id, String order_id) async{
    orders.document(restaurant_id).collection(order_id).getDocuments().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
    });
  }

  Future<String> createOrderData(String restaurant_id, String order_id, String entry_id, int amount, bool send) async {
    DocumentReference ref = orders.document(restaurant_id).collection(order_id).document();
    await ref.setData({
      'amount': amount,
      'entry_id': entry_id,
      'send': send,
    });
    return ref.documentID;
  }

  Future updateOrderData(String restaurant_id, String table_id, Order order) async {
    DocumentReference ref = orders.document(restaurant_id).collection(table_id).document(order.order_id);
    await ref.setData({
      'amount': order.amount,
      'entry_id': order.entry_id,
      'send': order.send,
    });
  }

  //No necesario aun
  Stream<Order> getOrderItem(String restaurant_id, String order_id, String item_id) {
    return orders.document(restaurant_id).collection(order_id).document(item_id).snapshots().map((s) => Order(
      order_id: s.documentID,
      amount: s.data['amount'],
      entry_id: s.data['entry_id'],
      send: s.data['send']
    ));
  }

  Stream<List<Order>> getOrder(String restaurant_id, String order_id) {
    return orders.document(restaurant_id).collection(order_id).snapshots().map((event) => event.documents.where((element) => element.documentID != "closed").map((s) {
        return Order(
            order_id: s.documentID,
            amount: s.data['amount'],
            entry_id: s.data['entry_id'],
            send: s.data['send']
        );
    }).toList());
  }

  Stream<bool> checkClose(String restaurant_id, String order_id) {
    return orders.document(restaurant_id).collection(order_id).document("closed").snapshots().map((s) => s.data['closed']);
  }

}