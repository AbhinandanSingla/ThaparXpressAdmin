import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CurrentState extends ChangeNotifier {
  bool loginState = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  SharedPreferences prefs;

  preference() async {
    prefs = await SharedPreferences.getInstance();
  }

  register(
      {String email, String pass, String name, BuildContext context}) async {
    print(''
        '++++++++++++++++');
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    ))
        .user;
    print(user);
    if (user != null) {
      print('$user------------------');
      prefs.setString('login', user.uid);
      prefs.setBool('loginSuccess', true);
      _firestore
          .collection('restaurants')
          .doc(user.uid)
          .set({'name': name.toString(), 'orders': []});
      print(''
          '++++++++++++++++');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      print('nul++++');
    }
    notifyListeners();
  }

  login(String email, String pass, context) async {
    loginState = true;
    notifyListeners();
    try {
      UserCredential _cred =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      user = _cred.user;
      prefs.setString('login', user.uid);
      prefs.setBool('loginSuccess', true);
      loginState = false;
      notifyListeners();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } catch (e) {
      print('$e+++++++++++++++++++++');
      loginState = false;
      notifyListeners();
      Fluttertoast.showToast(
              msg: "Email or Password is not correct",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepOrange,
              textColor: Colors.white,
              fontSize: 20.0)
          .toString();
    }
  }
}
