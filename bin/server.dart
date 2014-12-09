library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'entities/entity.dart';

import 'package:vane/vane.dart';
import 'package:game_loop/game_loop_isolate.dart';
import 'game_world/game_world.dart';
import 'package:the_quest_for_pi/globals.dart';

part 'server_handler.dart';

PhysicsState ps;
//ServerState ss;

StreamController pingClients = new StreamController.broadcast();


class Game extends Vane {
  @Route("/ws")
  Future main() {
    ServerHandler serverHandler = new ServerHandler();
    // Start listening to websocket connection
    StreamSubscription conn = ws.listen(null);
    // Set ping interval to prevent disconnection from peers
    ws.pingInterval = new Duration(seconds: 5);
    // Add all incoming message to the stream
    conn.onData((String msg) {
      serverHandler.handle(ws, conn, JSON.decode(msg));
    });

    pingClients.stream.listen((msg){
      ws.add(msg);
    });

    // On error, log warning
    conn.onError((e) => log.warning(e));

    // Close connection if websocket closes
    conn.onDone(() {
      serverHandler.connectionDone(close, conn);
    });
    return end;
  }
}


void main() {
  GameWorld.initWorld();
  PhysicsState ps = new PhysicsState()..physicsLoop.start();
  //ServerState ss = new ServerState()..serverLoop.start();
  serve();

}