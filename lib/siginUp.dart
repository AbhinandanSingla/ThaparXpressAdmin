import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tasteatlasadmin/ModelsAndProviders/currentState.dart';
import 'package:tasteatlasadmin/login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _email = TextEditingController();

  TextEditingController _pass = TextEditingController();

  TextEditingController _name = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CurrentState _currentState =
        Provider.of<CurrentState>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Hello Again!',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Signup to',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'get started',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                    ],
                  )),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: size.width,
                          decoration: BoxDecoration(color: Colors.white),
                          child: TextFormField(
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
                              hintText: 'Name',
                            ),
                            controller: _name,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(10),
                            width: size.width,
                            decoration: BoxDecoration(color: Colors.white),
                            child: TextFormField(
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
                              controller: _email,
                            )),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: size.width,
                          decoration: BoxDecoration(color: Colors.white),
                          child: TextFormField(
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
                            controller: _pass,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          onPressed: () async {
                            if (_email.value.text.isNotEmpty) {
                              if (_pass.value.text.isNotEmpty) {
                                if (_name.value.text.isNotEmpty) {
                                  if (_pass.value.text.length >= 6) {
                                    _currentState.register(
                                        email: _email.value.text,
                                        pass: _pass.value.text,
                                        name: _name.value.text,
                                        context: context);
                                  } else {
                                    print(_pass.value.text.length);
                                    Fluttertoast.showToast(
                                            msg:
                                                "Password length is too short it must be greater than 6 digits",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.deepOrange,
                                            textColor: Colors.black,
                                            fontSize: 20.0)
                                        .toString();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                          msg: "name Field is empty",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.deepOrange,
                                          textColor: Colors.black,
                                          fontSize: 20.0)
                                      .toString();
                                }
                              } else {
                                Fluttertoast.showToast(
                                        msg: "Password Field is empty",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.deepOrange,
                                        textColor: Colors.black,
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
                                      textColor: Colors.black,
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
                            InkWell(
                              child: Text('login'),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (ctx) => LoginPage()),
                                    (route) => false);
                              },
                            ),
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _pass.dispose();
    _name.dispose();
  }
}
