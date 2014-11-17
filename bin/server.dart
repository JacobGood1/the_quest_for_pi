library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:vane/vane.dart';
import 'package:game_loop/game_loop_isolate.dart';
import 'package:uuid/uuid.dart';

part 'game.dart';

WebSocket webSocket;
Uuid uuid = new Uuid();

List<Map> clientsConnected = [];

class Game extends Vane {


  @Route("/ws")
  Future main() {
    // Start listening to websocket connection
    StreamSubscription conn = ws.listen(null);
    webSocket = ws;

    // Set ping interval to prevent disconnection from peers
    ws.pingInterval = new Duration(seconds: 5);
    // Add all incoming message to the stream
    conn.onData((String msg) {

      clientInput.add(msg);
      log.info(msg);

      Map decoded_msg = JSON.decode(msg);

      if(decoded_msg['clientID'] == ''){ //if clientID is '', this is a new client connection.
        String id = uuid.v4();
        websocketSend({'ID':{'clientID': id},
                       'exisitingClients': clientsConnected}); //new connection is found, send a proper client ID as well as the existing entities within the server.

        decoded_msg.remove('clientID');
        decoded_msg.putIfAbsent('clientID', () => id);

        print(decoded_msg);
        clientsConnected.add(decoded_msg);
      }

      //clientInput.clear();
    });

    // On error, log warning
    conn.onError((e) => log.warning(e));

    // Close connection if websocket closes
    conn.onDone(() {
      close();
    });
    return end;
  }
}

void websocketSend(Map<String, Object> map){
  webSocket.add(JSON.encode(map));
}

void main() {
  PhysicsState ps = new PhysicsState()..physicsLoop.start();
  ServerState ss = new ServerState()..serverLoop.start();
  serve();
}

