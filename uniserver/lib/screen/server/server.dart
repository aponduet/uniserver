import 'package:flutter/material.dart';
import 'package:uniserver/controller/resetter.dart';
import 'package:uniserver/controller/websocket.dart';
import 'package:uniserver/data/app_states.dart';

class Server extends StatefulWidget {
  const Server({Key? key}) : super(key: key);

  @override
  ServerState createState() => ServerState();
}

class ServerState extends State<Server> {
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
        title: const Text("Server"),
      ),
      body: Container(
        child: const Center(
          child: Text("I am Server"),
        ),
      ),
    );
  }
}
