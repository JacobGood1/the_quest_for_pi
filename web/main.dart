library client;

import 'dart:html';
import 'dart:convert';
import 'package:stagexl/stagexl.dart';
import 'package:the_quest_for_pi/globals.dart';
import 'levels/level.dart';

part 'client_handler.dart';

CanvasElement canvas = querySelector('#stage')
  ..width = canvasWidth
  ..height = canvasHeight;
Stage stage = new Stage(canvas);
RenderLoop loop = new RenderLoop();
GameLoop gameLoop = new GameLoop();

WebSocket webSocket;

String ID = '';

List<Map> entities = [ID];

ClientHandler clientHandler = new ClientHandler();


class GameLoop extends Animatable{
  bool advanceTime(num time) {
    currentLevel.updateSprites(time);
    return true;
  }
}

class WebsocketSetup {
  WebSocket ws;
  WebsocketSetup() {
    // Initialize Websocket connection (9090 for during development locally,
    // otherwise use standard port 80 for production)
    Uri uri = Uri.parse(window.location.href);
    var port = uri.port != 8080 ? 80 : 9090; //production
    //var port = uri.port != 63342 ? 80 : 9090; //JACOB

    //var port = uri.port != 55125 ? 80 : 9090; //TRAVIS

    ws = new WebSocket("ws://${uri.host}:${port}/ws");
    // Listen for Websocket events

    ws.onOpen.listen((e)  => clientHandler.onOpen(ws));
    ws.onClose.listen((e) => clientHandler.onClose(ws));
    ws.onError.listen((e) => clientHandler.onError(ws));

    // Collect messages from the stream
    ws.onMessage.listen((MessageEvent message) {
      Map msg = websocketRead(message);
      clientHandler.handle(msg);
    });


  }
}

Level currentLevel;

void main(){
  stage.focus=stage;
  loop.addStage(stage);
  stage.juggler.add(gameLoop);
  var wsSetup = new WebsocketSetup();
  currentLevel = new Level1(stage);

}

