library game_world_client;

import '../entities/entity.dart';
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import '../main.dart';
import 'input_manager.dart';
import 'package:the_quest_for_pi/globals.dart' as g;


CanvasElement canvas = (querySelector('#stage') as CanvasElement)
  ..width = g.canvasWidth
  ..height = g.canvasHeight;
Stage stage = new Stage(canvas);
RenderLoop loop = new RenderLoop();
GameLoop gameLoop = new GameLoop();

class GameLoop extends Animatable{
  bool advanceTime (num time) {
    if(GameWorld.isGameWorldReady) {
      clientHandler.outgoingMessage(g.MessageTypes.CLIENT_INPUT, InputManager.currentActiveKeys.toString());
    }
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
  static List<Map> serverEntities = [], serverPlayers = [];
  GameWorld(Map messageFromServerData){
    new InputManager(stage);

    List entities = messageFromServerData['entityManager'] as List;
    List players = messageFromServerData['playerEntities'] as List;

    List<List> assets = messageFromServerData['assets'];
    assets.forEach((List asset) => resourceManager.addBitmapData(asset[0], asset[1]));
    resourceManager
      ..addTextureAtlas('mageAnimation0', 'assets/animations/wizard0.json', TextureAtlasFormat.JSONARRAY)
      ..addTextureAtlas('mageAnimation1', 'assets/animations/wizard1.json', TextureAtlasFormat.JSONARRAY)
      ..addTextureAtlas('goblin', 'assets/animations/gobby.json', TextureAtlasFormat.JSONARRAY)
      ..addSound('footstep', 'assets/sounds/footstep.wav');
    resourceManager.load().then((_) {
      entities.forEach((Map entity) => GameWorld.addEntity(makeNewObjectFromJSON(entity)));
      players.forEach((Map entity) {GameWorld.addPlayerEntity(makeNewObjectFromJSON(entity));});
      stage.focus=stage;
      loop.addStage(stage);
      stage.juggler.add(gameLoop);
      isGameWorldReady = true;
    });
  }


  void updateEntities(num time){
    GameWorld.entityManager.forEach((entity) => entity.updateAllComponents(time));
  }
  static void removePlayer(String id){
    for(var i = 0; i < GameWorld.playerEntities.length; i++){
      Player player = GameWorld.playerEntities[i];
      if(player.ID == id){
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
    GameWorld.playerEntities.clear();
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
  static void addPlayerEntity(Entity e){
    GameWorld.playerEntities.add(e);
    stage.addChild(e);
  }
  static get getStage => stage;
  Map toJson() {
    return {'playerEntities' : playerEntities.map((e) => e.toJson).toList(),
            'entityManager'  : GameWorld.entityManager.map((e) => e.toJson).toList()};
  }
}
makeNewObjectFromJSON(Map entity){
  String type = entity['type'],
           id = entity['ID'];
  double posX = entity['positionX'],
         posY = entity['positionY'];
  if(type == 'Bush'){
    return new Bush(id, posX,posY);
  }else if(type == 'Bat'){
    return new Bat(id, posX, posY);
  }else if(type == 'Player'){
    return new Player(
        id,
        posX,
        posY,
        entity['currentAnimationFrame'],
        entity['currentAnimationState'],
        entity['currentSoundState']);
  }
}