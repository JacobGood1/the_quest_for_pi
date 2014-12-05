library client;

import 'dart:html';
import 'dart:convert';
import 'package:the_quest_for_pi/globals.dart';
import 'game_world/game_world.dart';
import 'entities/entity.dart';
part 'client_handler.dart';


WebSocket webSocket;
String ID = '';

List<String> currentClientKeys = [];

ClientHandler clientHandler = new ClientHandler();


Uri uri;

class WebsocketSetup {
  WebSocket ws;
  WebsocketSetup() {
    // Initialize Websocket connection (9090 for during development locally,
    // otherwise use standard port 80 for production)
    uri = Uri.parse(window.location.href);
    ws = new WebSocket("ws://${uri.host}:${port}/ws");
    // Listen for Websocket events

    ws.onOpen.listen((e)  => clientHandler.onOpen(ws));
    ws.onClose.listen((e) => clientHandler.onClose(ws));
    ws.onError.listen((e) => clientHandler.onError(ws));

    // Collect messages from the stream
    ws.onMessage.listen((MessageEvent message) {
      clientHandler.incomingMessage(JSON.decode(message.data));
    });
  }
}


void main(){
  new WebsocketSetup();
}