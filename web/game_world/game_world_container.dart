library game_world_client;

import '../entities/entity.dart';
import 'dart:html';
import 'package:stagexl/stagexl.dart'
  show
    Stage,
    ResourceManager,
    Animatable,
    TextureAtlasFormat,
    Bitmap,
    RenderLoop,
    FlipBook;
import '../main.dart';
import 'input_manager.dart';
import 'package:the_quest_for_pi/globals.dart' as g;
import 'dart:async' show Timer;

part 'combat_world.dart';
part 'main_game_world.dart';

CanvasElement canvas = (querySelector('#stage') as CanvasElement)
  ..width = g.canvasWidth
  ..height = g.canvasHeight;

ResourceManager rm = new ResourceManager()
  ..addTextureAtlas('mageAnimation0', 'assets/animations/wizard0.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('mageAnimation1', 'assets/animations/wizard1.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('goblin', 'assets/animations/gobby.json', TextureAtlasFormat.JSONARRAY)
  ..addSound('footstep', 'assets/sounds/footstep.wav')
  ..addBitmapData('Bush', 'assets/images/bush.png')
  ..addBitmapData('Bat', 'assets/images/bat.png')
  ..addBitmapData('Goblin', 'assets/images/goblin.png')
  ..addBitmapData('Player', 'assets/images/black_mage.png')
  ..addBitmapData('CombatStar', 'assets/images/combatStartedWorld.png')
  ..addBitmapData('backGroundCombat', 'assets/images/background_Combat.png');


class GameLoop extends Animatable{
  bool advanceTime (num time) {
    if(currentGameWorld != null){
      if(currentGameWorld.isGameWorldReady) {
        clientHandler.outgoingMessage(g.MessageTypes.CLIENT_INPUT, InputManager.currentActiveKeys.toString());
      }
    }
    return true;
  }
}



abstract class GameWorldContainer{
  static bool _firstTime = true;
  static Stage combatStage = new Stage(canvas)..width = 1000..height = 1000;
  String ID;
  List<Player> playerEntities = [];
  List<Entity> entities = [];
  bool isGameWorldReady = false;
  ResourceManager resourceManager;
  Stage stage;
  RenderLoop loop;
  GameLoop gameLoop;
  void addPlayerEntity(Entity e);
  void removePlayer(String id);
  void addEntity(Entity e);
  void updateEntities(List<Map>serverEntities, List<Map>serverPlayers, num dt);

  GameWorldContainer(){
    stage = new Stage(canvas);
    loop = new RenderLoop();
    gameLoop = new GameLoop();
    resourceManager = rm;
    new InputManager(stage);
    stage.focus=stage;
    loop.addStage(stage);
    stage.juggler.add(gameLoop);
  }

  //this will make client side entities then add them to the client
  void generateObjectsFromServerEntities(Map messageData){  //TODO might need to make server and player entity non null?
    List serverPlayers = messageData['playerEntities'] as List;  //TODO this code is cancelling out the backgound when just one goblin and player exist find out why
    List serverEntities = messageData['entities'] as List;
    if(serverPlayers != null && serverEntities == null){
      serverPlayers.forEach((Map entity) {addPlayerEntity(makeNewObjectFromJSON(entity));});
    }else if(serverPlayers == null && serverEntities != null){
      serverEntities.forEach((Map entity) => addEntity(makeNewObjectFromJSON(entity)));
    }
    else{
      serverEntities.forEach((Map entity) => addEntity(makeNewObjectFromJSON(entity)));
      serverPlayers.forEach((Map entity) {addPlayerEntity(makeNewObjectFromJSON(entity));});
    }
  }
  //call this at the end of an instance constructor
  initGameWorld(Map message, Function delayedSetup){
    if(_firstTime){
      rm.load().then((_) {
        CombatGameWorld.backGround = new Bitmap(rm.getBitmapData('backGroundCombat'))
          ..scaleX = 2
          ..scaleY = 2;
        _firstTime = false;
        new Timer(new Duration(milliseconds: 0), () {delayedSetup(); isGameWorldReady = true;});
      });
    } else{
      new Timer(new Duration(milliseconds: 0), () {delayedSetup(); isGameWorldReady = true;});
    }
  }
}
