library game_world_client;

import '../entities/entity.dart';
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'dart:mirrors';
import '../main.dart';
import 'input_manager.dart';
import '../../bin/globals.dart' as g;
import 'dart:convert';  //TODO delete this test code when done


CanvasElement canvas = (querySelector('#stage') as CanvasElement)
  ..width = g.canvasWidth
  ..height = g.canvasHeight;
Stage stage = new Stage(canvas);
RenderLoop loop = new RenderLoop();
GameLoop gameLoop = new GameLoop();

class GameLoop extends Animatable{
  bool advanceTime(num time) {
    InputManager.updateInputProcessor(time);
    clientHandler.outgoingMessage(g.MessageTypes.CLIENT_INPUT, InputManager.currentActiveKeys.toString());
    GameWorld.entityManager.forEach((Entity entity) => entity.updateAllComponents(time));
    return true;
  }
}

class GameWorld{
  static bool isGameWorldReady = false;
  static ResourceManager resourceManager = new ResourceManager();
  var entitySize = 64.0;
  var entityOffset = 32.0; //size / 2.0;
  static List playerEntities = [], assets = [];
  static List<Entity> entityManager = [];
  
  GameWorld(Map messageFromServerData){
    new InputManager(stage);
    List entities = messageFromServerData['entityManager'] as List;
    List<List> assets = messageFromServerData['assets'];
    assets.forEach((List asset) => resourceManager.addBitmapData(asset[0], asset[1]));
    resourceManager.load().then((_) {
      isGameWorldReady = true;
      entities.forEach((Map entity) => GameWorld.addEntity(makeNewObjectFromJSON(entity)));
      stage.focus=stage;
      loop.addStage(stage);
      stage.juggler.add(gameLoop);
    });
  }


  void updateEntities(num time){
    GameWorld.entityManager.forEach((entity) => entity.updateAllComponents(time));
  }
  static void removePlayer(String id){
    for(var i = 0; i < GameWorld.playerEntities.length; i++){
      Player player = GameWorld.playerEntities[i];
      print(player.ID);
      if(player.ID == id){
        print('found');
        GameWorld.playerEntities.remove(player);
        stage.removeChild(player);
        break;
      }
    }
  }
  static void clearEntities(){
    if(stage.numChildren != 0){
      stage.removeChildren(0,stage.numChildren - 1);
    }
    GameWorld.entityManager.clear();
  }

  void addEntities(List<Entity> e){
    e.forEach((Entity e){
      GameWorld.entityManager.add(e);
      stage.addChild(e);
    });
  }

  static void addEntity(Entity e){
    GameWorld.entityManager.add(e);
    stage.addChild(e);
  }

  Map toJson() {
    return {'playerEntities' : playerEntities.map((e) => e.toJson).toList(),
            'entityManager'  : GameWorld.entityManager.map((e) => e.toJson).toList()};
  }
}
makeNewObjectFromJSON(Map entity){
  String type = entity['type'];
  double posX = entity['positionX'],
         posY = entity['positionY'];
  if(type == 'Bush'){
    return new Bush(posX,posY);
  }else if(type == 'Bat'){
    return new Bat(posX, posY);
  }else if(type == 'Player'){
    return new Player(posX, posY);
  }
}