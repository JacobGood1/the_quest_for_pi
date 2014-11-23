library server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:vane/vane.dart';
import 'package:game_loop/game_loop_isolate.dart';
import 'package:uuid/uuid.dart';
import 'package:the_quest_for_pi/globals.dart';


import 'entities/entity.dart';
import 'levels/level.dart';

part 'game.dart';
part 'server_handler.dart';


Uuid uuid = new Uuid();

WebSocket webby;

Map<StreamSubscription, String> clientWebsocketPointers = {};

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
      //log.info(msg); //TODO log something later?  give the logger to the handler?
      serverHandler.handle(ws, conn, JSON.decode(msg));
    });

    // On error, log warning
    conn.onError((e) => log.warning(e));

    // Close connection if websocket closes
    conn.onDone(() {
      serverHandler.connectionDone(close, conn);
    });
    PhysicsState ps = new PhysicsState()..physicsLoop.start();
    ServerState ss = new ServerState(ws)..serverLoop.start();

    return end;
  }
}

void main() {
  currentLevel = new Level1();
  serve();
}

