import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uniserver/controller/resetter.dart';
import 'package:uniserver/controller/sender.dart';
import 'package:uniserver/controller/websocket.dart';
import 'package:uniserver/data/app_states.dart';

class SingleShop extends StatefulWidget {
  final Websocket socketInstance;
  final AppStates appStatesInstance;
  final Resetter resetter;

  SingleShop({
    Key? key,
    //required this.socketInstance,
    required this.appStatesInstance,
    required this.socketInstance,
    required this.resetter,
  }) : super(key: key);
  @override
  State<SingleShop> createState() => _SingleShopState();
}

class _SingleShopState extends State<SingleShop> {
  // late Future<String?> webRTCconnectionStates;
  final LocalSender localSenderInstance = LocalSender();
  // LocalSender class Instance
  //final RemoteSender remoteSenderInstance = RemoteSender();
  // RemoteSender class Instance
  final Resetter reSetterInstance = Resetter();

  //Resetter class instance
  @override
  dispose() {
    //Dispose WebRTC connection here

    super.dispose();
  }

  //Initiate all connection
  @override
  void initState() {
    //Start WebRTC connection here
    widget.socketInstance.localInstance.createLocalConnection(
        widget.socketInstance.socket,
        widget.appStatesInstance,
        widget.resetter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
      ),
      body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<List<int>>(
                  valueListenable: widget.appStatesInstance.imageData,
                  builder: ((context, value, child) {
                    return value.isNotEmpty
                        ? SizedBox(
                            width: 500,
                            height: 400,
                            child: Image.memory(
                              Uint8List.fromList(value),
                              width: 450,
                              height: 350,
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                          );
                  })),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    localSenderInstance.sendEvent(
                        widget.socketInstance.localInstance.localDataChannel,
                        "getImage");
                  },
                  child: const Text("Get Image")),
            ],
          )),
    );
  }
}
