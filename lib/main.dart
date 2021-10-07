import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasteatlasadmin/ModelsAndProviders/MainScreenPRovider.dart';
import 'package:tasteatlasadmin/ModelsAndProviders/connectivity_status.dart';
import 'package:tasteatlasadmin/ModelsAndProviders/currentState.dart';
import 'package:tasteatlasadmin/TopContainer.dart';
import 'package:tasteatlasadmin/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainScreenProvider>(
            create: (context) => MainScreenProvider()),
        ChangeNotifierProvider<CurrentState>(
            create: (context) => CurrentState()),
        StreamProvider<ConnectionCheck>.value(
          value: CheckConnectionStatus().connectionChecker.stream,
        )
      ],
      child: MaterialApp(home: LoginPage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double totalAmount = 0;
  List ready = [];
  List orderIds = [];
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainScreenProvider _mainScreenProvider =
        Provider.of<MainScreenProvider>(context);
    ConnectionCheck _connectivity =
        Provider.of<ConnectionCheck>(context, listen: true);
    CurrentState _currentState = Provider.of<CurrentState>(context);
    print(_connectivity);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: TopContainer(minExtent: 200, maxExtent: 250),
            ),
            SliverToBoxAdapter(
              child: Consumer<MainScreenProvider>(
                builder: (BuildContext context, MainScreenProvider _provider,
                        Widget child) =>
                    Visibility(
                  visible: _provider.a,
                  child: child,
                ),
                child: StreamBuilder(
                  stream: _firestore
                      .collection('restaurants')
                      .doc(_currentState.prefs.getString('login'))
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    print(snapshot.data);
                    if (snapshot.data == null) {
                      return Text("you haven't place any order Yet");
                    }
                    if (snapshot.data['orders'].length == null) {
                      return Text("you haven't place any order Yet");
                    }
                    orderIds = snapshot.data['orders'];
                    print(orderIds);
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: orderIds.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return StreamBuilder(
                          stream: _firestore
                              .collection('currentOrder')
                              .doc(orderIds[index].toString())
                              .snapshots(),
                          builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
                            DocumentSnapshot documentSnapshot = snapshot.data;
                            print(orderIds);
                            try {
                              if (documentSnapshot.data() == null) {
                                return Text('No Pending order');
                              }
                            } catch (e) {
                              return Text('');
                            }

                            Map abcd = documentSnapshot.data();
                            print(
                                '${documentSnapshot.id}+++++++++++++++++++8888888888');
                            String keyId;
                            abcd.forEach((key, value) {
                              keyId = key;
                              print(key);
                            });
                            Map abc = abcd[keyId];
                            print(abc);

                            Timestamp dateTime =
                                abc.values.first['orderedTime'];
                            inProgress = abc.values.first['inProgress'];
                            print('$inProgress 5555555555555555555555555');
                            totalAmount = 0;
                            double tax = 5 / 100;
                            int CartTotal = 0;
                            abc.forEach((key, value) {
                              CartTotal += value['price'] * value['quantity'];
                            });
                            tax = double.parse(
                                (CartTotal * tax).toStringAsFixed(2));
                            totalAmount = CartTotal + tax;
                            return Visibility(
                              visible: inProgress,
                              child: Container(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                height: size.height * 0.4,
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'OrderID : ${orderIds[index]} | ${dateTime.toDate().hour}:${dateTime.toDate().minute} ',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.symmetric(
                                              horizontal: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ))),
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        itemCount: abc.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index2) {
                                          print(index2);
                                          String key = abc.keys.elementAt(
                                              index2); // key = product id
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${abc[key]['quantity']} X ${abc[key]['name']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      'Rs ${abc[key]['price']}')
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Text('Total bill : Rs ${totalAmount}'),
                                    InkWell(
                                      onTap: () {
                                        print(orderIds[index]);
                                        print(abc);

                                        _mainScreenProvider.prepared(
                                            orderIds[index], keyId, abc);
                                      },
                                      child: Container(
                                        height: 60,
                                        width: size.width - 50,
                                        decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: inProgress
                                                ? Text(
                                                    'Prepared',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18),
                                                  )
                                                : Text(
                                                    'Delivery Pending',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Consumer<MainScreenProvider>(
                    builder: (BuildContext context,
                            MainScreenProvider _provider, Widget child) =>
                        Visibility(
                      visible: _provider.b,
                      child: child,
                    ),
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('restaurants')
                          .doc(_currentState.prefs.getString('login'))
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        print(snapshot.data);
                        if (snapshot.data == null) {
                          return Text("you haven't place any order Yet");
                        }
                        if (snapshot.data['orders'].length == null) {
                          return Text("you haven't place any order Yet");
                        }
                        orderIds = snapshot.data['orders'];
                        print(orderIds);
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: orderIds.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return StreamBuilder(
                              stream: _firestore
                                  .collection('currentOrder')
                                  .doc(orderIds[index].toString())
                                  .snapshots(),
                              builder: (ctx, AsyncSnapshot<dynamic> snapshot) {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data;

                                try {
                                  if (documentSnapshot.data() == null) {
                                    return Center(
                                        child: Text('No Pending Orders'));
                                  }
                                } catch (e) {
                                  return Text('');
                                }

                                Map abcd = documentSnapshot.data();
                                String keyId;

                                abcd.forEach((key, value) {
                                  keyId = key;
                                });
                                Map abc = abcd[keyId];
                                print(abc);
                                Timestamp dateTime =
                                    abc.values.first['orderedTime'];
                                inProgress = abc.values.first['inProgress'];
                                totalAmount = 0;
                                double tax = 5 / 100;
                                int CartTotal = 0;
                                abc.forEach((key, value) {
                                  CartTotal +=
                                      value['price'] * value['quantity'];
                                });
                                tax = double.parse(
                                    (CartTotal * tax).toStringAsFixed(2));
                                totalAmount = CartTotal + tax;
                                return Visibility(
                                  visible: !inProgress,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    height: size.height * 0.4,
                                    margin: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'OrderID : ${orderIds[index]} | ${dateTime.toDate().hour}:${dateTime.toDate().minute} ',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.symmetric(
                                                  horizontal: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ))),
                                          child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            itemCount: abc.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              print(index2);
                                              String key = abc.keys.elementAt(
                                                  index2); // key = product id
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${abc[key]['quantity']} X ${abc[key]['name']}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          'Rs ${abc[key]['price']}')
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Text('Total bill : Rs ${totalAmount}'),
                                        InkWell(
                                          onTap: () {
                                            _mainScreenProvider.delivered(
                                                orderId: orderIds[index],
                                                uid: keyId,
                                                productList: abc,
                                                res: _currentState.prefs
                                                    .getString('login'));
                                          },
                                          child: Container(
                                            height: 60,
                                            width: size.width - 50,
                                            decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: inProgress
                                                    ? Text(
                                                        'Prepared',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 18),
                                                      )
                                                    : Text(
                                                        'Delivery Pending',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Consumer<MainScreenProvider>(
                    builder: (ctx, instance, v) => Visibility(
                        visible: !instance.sucessDelivered,
                        child: Container(
                            height: size.height * 0.5,
                            width: size.width,
                            color: Colors.white.withOpacity(0.8),
                            child: Lottie.asset(
                                'assets/animations/delivered.json'))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
