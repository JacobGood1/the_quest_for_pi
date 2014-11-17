import 'dart:html';
import 'dart:convert';
import 'package:stagexl/stagexl.dart';
import 'package:the_quest_for_pi/globals.dart';
import 'levels/level.dart';

CanvasElement canvas = querySelector('#stage')
  ..width = canvasWidth
  ..height = canvasHeight;
Stage stage = new Stage(canvas);
RenderLoop loop = new RenderLoop();
GameLoop gameLoop = new GameLoop();

WebSocket webSocket;

Map entity = {'clientID': '',
              'x': 0.0,
              'y': 0.0};

List<Map> entities = [entity];

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
    //var port = uri.port != 8080 ? 80 : 9090; //production
    var port = uri.port != 63342 ? 80 : 9090; //JACOB

    //var port = uri.port != 55125 ? 80 : 9090; //TRAVIS

    ws = new WebSocket("ws://${uri.host}:${port}/ws");
    // Listen for Websocket events

    ws.onOpen.listen((e) {
      print("Connected");
      webSocket = ws;
      websocketSend(entity);
    });
    ws.onClose.listen((e)   => print("Disconnected"));
    ws.onError.listen((e)   => print("Error"));

    // Collect messages from the stream
    ws.onMessage.listen((MessageEvent message) {
      //print(message.data);
      if(entity['clientID'] == ''){
        var decoderRing = JSON.decode(message.data);
        print(decoderRing.runtimeType);
        entity['clientID'] = decoderRing['ID']['clientID'];

        //get current clients connected
        List<Map> existingEntities = JSON.decode(message.data)['existingClients'];
        existingEntities.forEach((message){
          entities.add(message);
        });
      } else {
        List<Map> msg = websocketRead(message.data);
        //print("printing ${msg}");
        //entity['x'] = msg['x'];
        msg.forEach((m){
          //print("printing ${m['x']}");
        });


        //print(entity);
      }


    });


  }
}

void websocketSend(Map<String, Object> map){
  webSocket.send(JSON.encode(map));
}

List<Map> websocketRead(String msg){
  return JSON.decode(msg);
}

Level currentLevel;

void main(){
  stage.focus=stage;
  loop.addStage(stage);
  stage.juggler.add(gameLoop);
  var wsSetup = new WebsocketSetup();
  currentLevel = new Level1(stage);
}

