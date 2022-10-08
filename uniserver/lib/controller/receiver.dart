import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:uniserver/controller/resetter.dart';
import 'package:uniserver/controller/save_file.dart';
import 'package:uniserver/data/app_states.dart';
import 'package:uniserver/model/file_info.dart';
import 'package:uniserver/model/received_file.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

//*********** Local RECEIVER ********* */
//*********** Local RECEIVER ********* */
//*********** Local RECEIVER ********* */

class LocalReceiver {
  ReceivedFile receivedFileInstance = ReceivedFile();
  int totalChunks = 0;
  Saver localFileSaverInstance = Saver();
  localreceiver(
      RTCDataChannel? sendChannel, AppStates appStates, Resetter reSetter) {
    sendChannel!.onMessage = (message) {
      print('message reeived from server ${message.binary}');
      if (message.isBinary) {
        print('message reeived from server');
        appStates.imageData.value = message.binary;
        // appStates.receivedChunks.value.add(message.binary);
        // // Update progress bar value
        // double percent = (appStates.receivedChunks.value.length) / totalChunks;
        // //Show Received Progress Indicator
        // appStates.receiveProgressValue.value = percent;
        // appStates.isShowReceiveProgress.value = true;
      }
      if (!message.isBinary) {
        FileInfo fileheaders = FileInfo.fromJson(jsonDecode(message.text));
        if (!fileheaders.isFileInfo) {
          //used to show text on chatbox
          print(fileheaders.textmessage);
        }

        if (fileheaders.isFirstChunk) {
          totalChunks = fileheaders.totalChunk;
        }
        //save file to storage or download in web
        if (fileheaders.isLastChunk) {
          appStates.receiveProgressValue.value = 1;
          appStates.isShowReceiveProgress.value = false;
          appStates.isShowSaving.value = true;

          //Saving System
          Timer(const Duration(seconds: 2), () {
            localFileSaverInstance.saveFile(message.text, appStates, reSetter);
          });
        }
      }
    };
  }
}

//*********** REMOTE RECEIVER ********* */
//*********** REMOTE RECEIVER ********* */
//*********** REMOTE RECEIVER ********* */

class RemoteReceiver {
  int totalChunks = 0;
  Saver remoteFileSaverInstance = Saver();

  remoteReceiver(RTCDataChannel? receiveChannel, AppStates appStates,
      Resetter reSetterInstance) {
    receiveChannel!.onMessage = (message) async {
      if (message.isBinary) {
        appStates.receivedChunks.value.add(message.binary);
        // Update progress bar value
        double percent = (appStates.receivedChunks.value.length) / totalChunks;
        appStates.receiveProgressValue.value = percent;
        appStates.isShowReceiveProgress.value = true;
      }
      if (!message.isBinary) {
        if (message.text == 'getImage') {
          print("The event is : ${message.text}");
          Directory? dir;
          dir = await getDownloadsDirectory();
          print(dir!.path);
          // String correctPath = dir.path.replaceAll(r'\', '/');
          String filePath = "${dir.path.replaceAll(r'\', '/')}/rana.jpg";
          print(filePath);
          File file = File(filePath);
          Uint8List bytes = file.readAsBytesSync();
          RTCDataChannelMessage imageBytes =
              RTCDataChannelMessage.fromBinary(bytes);
          //print(bytes);
          try {
            receiveChannel.send(imageBytes);
            print("Data is sent to local.");
          } catch (e) {
            print(e);
          }
        }

        // FileInfo fileheaders = FileInfo.fromJson(jsonDecode(message.text));
        // if (!fileheaders.isFileInfo) {
        //   //used to show text on chatbox
        //   print(fileheaders.textmessage);
        // }

        // if (fileheaders.isFirstChunk) {
        //   totalChunks = fileheaders.totalChunk;
        // }
        // //save file to storage or download in web
        // if (fileheaders.isLastChunk) {
        //   appStates.receiveProgressValue.value = 1;
        //   appStates.isShowReceiveProgress.value = false;
        //   appStates.isShowSaving.value = true;
        //   //Saving System
        //   Timer(const Duration(seconds: 2), () {
        //     //save file after two seconds
        //     remoteFileSaverInstance.saveFile(
        //         message.text, appStates, reSetterInstance);
        //   });
        // }
      }
    };
  }
}
