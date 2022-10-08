import 'package:flutter/material.dart';
import 'package:uniserver/controller/resetter.dart';
import 'package:uniserver/controller/websocket.dart';
import 'package:uniserver/data/app_states.dart';
import 'package:uniserver/screen/client/single_shop.dart';

class ShopList extends StatelessWidget {
  final AppStates appStates;
  final Resetter resetter;
  final Websocket socketInstance;
  const ShopList({
    Key? key,
    required this.appStates,
    required this.resetter,
    required this.socketInstance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: appStates.shopList.value.length ,
          itemCount: 20,
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleShop(
                                appStatesInstance: appStates,
                                socketInstance: socketInstance,
                                resetter: resetter,
                              )));
                  //Move to the Shop Landing page
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Center(child: Text("Shop Name")),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
