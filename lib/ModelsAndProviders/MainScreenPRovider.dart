import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasteatlasadmin/ModelsAndProviders/connectivity_status.dart';

class MainScreenProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool a = true;
  bool b = false;
  bool c = false;
  bool sucessDelivered = true;

  void refresh() {
    notifyListeners();
  }

  search(id) {
    final orders = _firestore.collection('currentOrder').snapshots();
    orders.forEach((element) {
      print(element);
    });
  }

  prepared(String orderId, String uid, Map productList) async {
    productList.forEach((key, value) {
      value["inProgress"] = false;
      print('$value 99999999999999999999999');
    });
    await _firestore
        .collection('currentOrder')
        .doc(orderId)
        .update({uid: productList});
    notifyListeners();
  }

  delivered({String orderId, String uid, String res, Map productList}) async {
    print('clicked');
    sucessDelivered = false;
    notifyListeners();
    productList.forEach((key, value) {
      value["delivered"] = true;
    });
    await _firestore
        .collection('currentOrder')
        .doc(orderId)
        .update({uid: productList});

    await _firestore.collection('currentOrder').doc(orderId).delete();
    await _firestore.collection('restaurants').doc(res).update({
      'orders': FieldValue.arrayRemove([orderId])
    });
    try {
      await _firestore.collection('user').doc(uid).update({
        'currentOrder': FieldValue.arrayRemove([orderId])
      });
      sucessDelivered = true;
    } catch (e) {
      sucessDelivered = true;
    }
    notifyListeners();
  }
}

class CheckConnectionStatus {
  StreamController<ConnectionCheck> connectionChecker =
      StreamController<ConnectionCheck>();

  CheckConnectionStatus() {
    DataConnectionChecker().onStatusChange.listen((status) {
      var ConnectionStatus = _check(status);
      connectionChecker.add(ConnectionStatus);
    });
  }

  ConnectionCheck _check(DataConnectionStatus _status) {
    switch (_status) {
      case DataConnectionStatus.disconnected:
        return ConnectionCheck.Offline;
      case DataConnectionStatus.connected:
        return ConnectionCheck.Working;
      default:
        return ConnectionCheck.Offline;
    }
  }
}
