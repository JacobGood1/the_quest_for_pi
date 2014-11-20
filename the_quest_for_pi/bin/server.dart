library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:vane/vane.dart';
import 'package:game_loop/game_loop_isolate.dart';
import 'package:uuid/uuid.dart';
import 'package:the_quest_for_pi/globals.dart';

part 'game.dart';
part 'server_handler.dart';

WebSocket webSocket;
Uuid uuid = new Uuid();

ServerHandler serverHandler = new ServerHandler();

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
      log.info(msg);
      serverHandler.handle(JSON.decode(msg));



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

