import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:provider/provider.dart';
import 'package:tasteatlasadmin/ModelsAndProviders/currentState.dart';

import 'ModelsAndProviders/MainScreenPRovider.dart';

class TopContainer implements SliverPersistentHeaderDelegate {
  TopContainer({
    this.minExtent,
    @required this.maxExtent,
  });

  final double minExtent;
  final double maxExtent;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _controller = TextEditingController();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    MainScreenProvider _mainscreenProvider =
        Provider.of<MainScreenProvider>(context);
    CurrentState _currentState = Provider.of<CurrentState>(context);
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thapar Xpress',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.green),
          ),
          Text(
            'Accepting Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            // padding: EdgeInsets.only(right: 10, left: 10),
            height: 40,
            width: size.width,
            child: TextField(
              onChanged: (value) {},
              controller: _controller,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search by order id ',
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<MainScreenProvider>(builder:
                (BuildContext context, MainScreenProvider value, Widget child) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _mainscreenProvider.a = true;
                      _mainscreenProvider.b = false;
                      _mainscreenProvider.c = false;

                      value.refresh();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: size.width * 0.4,
                      height: 50,
                      decoration: BoxDecoration(
                          color: _mainscreenProvider.a
                              ? Colors.deepOrange
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Preparing',
                        style: TextStyle(
                            color: _mainscreenProvider.a
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _mainscreenProvider.a = false;

                      _mainscreenProvider.b = true;
                      _mainscreenProvider.c = false;
                      value.refresh();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: size.width * 0.4,
                      height: 50,
                      decoration: BoxDecoration(
                          color: _mainscreenProvider.b
                              ? Colors.deepOrange
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Ready',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _mainscreenProvider.b
                              ? Colors.white
                              : Colors.black,
                        ),
                      )),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _mainscreenProvider.a = false;
                  //     _mainscreenProvider.b = false;
                  //     _mainscreenProvider.c = true;
                  //     value.refresh();
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     width: size.width / 3,
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //         color: _mainscreenProvider.c
                  //             ? Colors.deepOrange
                  //             : Colors.white,
                  //         borderRadius: BorderRadius.circular(8)),
                  //     child: Center(
                  //         child: Text(
                  //       'History)',
                  //       style: TextStyle(
                  //           color: _mainscreenProvider.c
                  //               ? Colors.white
                  //               : Colors.black,
                  //           fontWeight: FontWeight.bold),
                  //     )),
                  //   ),
                  // )
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration =>
      throw UnimplementedError();

  @override
  // TODO: implement vsync
  TickerProvider get vsync => throw UnimplementedError();
}
