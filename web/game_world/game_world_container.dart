library game_world_client;

import '../entities/entity.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart'
  show
    Stage,
    ResourceManager,
    Animatable,
    TextureAtlasFormat,
    Bitmap,
    RenderLoop,
    FlipBook,
    Shape,
    Color,
    SimpleButton,
    Sprite,
    Rectangle,
    MouseEvent,
    TextField,
    TextFormat, GlowFilter, HtmlObject;
import '../main.dart' as main;
import 'input_manager.dart';
import 'package:the_quest_for_pi/globals.dart' as g;
import 'dart:async' show Timer;
part 'combat_world.dart';
part 'main_game_world.dart';

html.CanvasElement canvas = (html.querySelector('#stage') as html.CanvasElement)
  ..width = g.canvasWidth
  ..height = g.canvasHeight;

ResourceManager rm = new ResourceManager()
  ..addTextureAtlas('mageAnimation0', 'assets/animations/wizard0.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('mageAnimation1', 'assets/animations/wizard1.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('goblin', 'assets/animations/gobby.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('fireball_explosion', 'assets/animations/fireball/explosion/explosion.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('fireball_loop', 'assets/animations/fireball/loop/loop.json', TextureAtlasFormat.JSONARRAY)
  ..addTextureAtlas('fireball_start', 'assets/animations/fireball/start/start.json', TextureAtlasFormat.JSONARRAY)
  ..addSound('footstep', 'assets/sounds/footstep.wav')
  ..addBitmapData('Bush', 'assets/images/bush.png')
  ..addBitmapData('Spear', 'assets/images/goblin_spear.png')
  ..addBitmapData('Bat', 'assets/images/bat.png')
  ..addBitmapData('Goblin', 'assets/images/goblin.png')
  ..addBitmapData('Player', 'assets/images/black_mage.png')
  ..addBitmapData('CombatStar', 'assets/images/combatStartedWorld.png')
  ..addBitmapData('backGroundCombat', 'assets/images/background_Combat.png')
  ..addBitmapData('spell_hotbar', 'assets/images/UI_hotbar.png')
  ..addBitmapData('UI_fireball', 'assets/images/UI_fireball.png')
  ..addBitmapData('UI_fireball_downstate', 'assets/images/UI_fireball_downstate.png')
  ..addBitmapData('UI_fireball_upstate', 'assets/images/UI_fireball_upstate.png');


class GameLoop extends Animatable{
  bool advanceTime (num time) {
    if(main.currentGameWorld != null){
      if(main.currentGameWorld is GameWorld){
        if(main.currentGameWorld.isGameWorldReady) {
          main.clientHandler.outgoingMessage(g.MessageTypes.CLIENT_INPUT, InputManager.currentActiveKeys.toString());
        }
      }
      else if(main.currentGameWorld is CombatGameWorld){
        main.clientHandler.outgoingMessage(g.MessageTypes.CLIENT_ANSWER, InputManager.answerFromClient);
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
  void removeEntity(Entity e);
  void updateEntities(List<Map>serverEntities, List<Map>serverPlayers, num dt);
  Shape healthLine = new Shape();
  bool _hasAddedHealthBarGameWorldContainer = false;

  GameWorldContainer(){
    stage = new Stage(canvas);
    loop = new RenderLoop();
    gameLoop = new GameLoop();
    resourceManager = rm;
    stage.focus=stage;
    loop.addStage(stage);
    stage.juggler.add(gameLoop);
  }

  drawHealthBars(){ //TODO get entity draw line working as well
    if(!_hasAddedHealthBarGameWorldContainer){
      stage.addChild(healthLine);
      _hasAddedHealthBarGameWorldContainer = false;
    }
    healthLine.graphics.clear();
    entities.forEach((Entity ent) {
      if(ent is Goblin){
        Goblin gobby = ent;
        healthLine.graphics
          ..beginPath()
          ..moveTo(gobby.position.x + 10,gobby.position.y - 5)
          ..fillColor(Color.Red)
          ..lineTo(gobby.position.x + 10 + gobby.health / 3, gobby.position.y - 5)
          ..strokeColor(Color.Red)
          ..closePath();
      }

    });
    playerEntities.forEach((Player player) {
      healthLine.graphics
        ..beginPath()
        ..moveTo(player.position.x + 10,player.position.y - 5)
        ..fillColor(Color.Red)
        ..lineTo(player.position.x + 10 + player.health / 3, player.position.y - 5)
        ..strokeColor(Color.Red)
        ..closePath();
    });
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
