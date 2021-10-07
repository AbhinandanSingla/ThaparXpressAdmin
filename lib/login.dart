import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasteatlasadmin/main.dart';

import 'ModelsAndProviders/currentState.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();

  TextEditingController _pass = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      final _currentProvider =
          Provider.of<CurrentState>(context, listen: false);
      _currentProvider.preference().then((d) {
        if (_currentProvider.prefs.getString('login') != null) {
          print(_currentProvider.prefs.getString('login'));
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyHomePage()));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    CurrentState _currentProvider =
        Provider.of<CurrentState>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello Again!',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Welcome',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'back',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                        ],
                      )),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              width: size.width,
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: 'Email Address',
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: size.width,
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextFormField(
                                controller: _pass,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            FlatButton(
                              onPressed: () {
                                if (_email.value.text.isNotEmpty) {
                                  if (_pass.value.text.isNotEmpty) {
                                    _currentProvider.login(_email.value.text,
                                        _pass.value.text, context);
                                  } else {
                                    Fluttertoast.showToast(
                                            msg: "Password Field is empty",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.deepOrange,
                                            textColor: Colors.white,
                                            fontSize: 20.0)
                                        .toString();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                          msg: "Login Field is empty",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.deepOrange,
                                          textColor: Colors.white,
                                          fontSize: 20.0)
                                      .toString();
                                }
                              },
                              child: Container(
                                width: size.width,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Forget your password'),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
                Consumer<CurrentState>(
                  builder: (ctx, instance, V) => Visibility(
                    visible: instance.loginState,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.white.withOpacity(0.8),
                      child: Lottie.asset('assets/animations/login.json'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
