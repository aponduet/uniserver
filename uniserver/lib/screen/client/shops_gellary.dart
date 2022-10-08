import 'package:flutter/material.dart';
import 'package:uniserver/controller/resetter.dart';
import 'package:uniserver/controller/websocket.dart';
import 'package:uniserver/data/app_states.dart';
import 'package:uniserver/view/shop_list.dart';

class Shop extends StatefulWidget {
  Shop({Key? key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final Websocket socketInstance = Websocket(); //socket Instance
  final AppStates appStatesInstance = AppStates(); // AppStates class Instance;
  final Resetter reSetterInstance = Resetter(); //Resetter class instance

  @override
  dispose() {
    //To stop multiple calling websocket, use the following code.
    socketInstance.disposeSocket();
    socketInstance.closeAllConnection();
    super.dispose();
  }

  //Initiate all connection
  @override
  void initState() {
    //socketConnection is an Instance of Active Websocket class
    socketInstance.startSocketConnection(appStatesInstance, reSetterInstance);
    super.initState();
    print("InitState is called, sOCKET iD : ${socketInstance.socket.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 250,
        child: ShopList(
          appStates: appStatesInstance,
          socketInstance: socketInstance,
          resetter: reSetterInstance,
        ),
      ),
    );
  }
}
