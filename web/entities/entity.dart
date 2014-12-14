library client_entity;

import 'package:stagexl/stagexl.dart' show Sprite, Bitmap, TextureAtlas;
import '../components/component.dart';
import 'package:the_quest_for_pi/base_entity.dart' as e show BaseEntity;
import 'package:the_quest_for_pi/globals.dart' as g;
import '../main.dart' show currentGameWorld;

//player
part '../entities/player.dart';

//terrian
part 'terrain/terrain.dart';
part 'terrain/bush.dart';

//flying creatures
part 'flying_creatures/flying_creature.dart';
part 'flying_creatures/bat.dart';

//goblin
part 'goblins/goblin.dart';

//props
part 'props/combat_star.dart';

abstract class Entity extends Sprite with e.BaseEntity{  //must be instantiated after the resource manager is done loading!
  Bitmap idleStillPic;
  Entity(String type, double posX, double posY, String ID){
    position = new g.Vector(posX, posY);
    initAllComponents();
    x = position.x;
    y = position.y;
    this.type = type;
    this.ID = ID;
    idleStillPic = new Bitmap(currentGameWorld.resourceManager.getBitmapData(type));
    addChild(idleStillPic);
  }
  @override
  void updatePositionsClient(){
    this..x = position.x ..y = position.y;
  }
  get entityManager => currentGameWorld.entities;

  void extractData(Map entity){
    this
      ..ID = entity['ID']
      ..position.x = entity['positionX']
      ..position.y = entity['positionY']
      ..currentAnimationFrame = entity['currentAnimationFrame']
      ..currentAnimationState = entity['currentAnimationState']
      ..currentSoundState = entity['currentSoundState']
      ..isDead = entity['isDead']
      ..inCombat = entity['inCombat'];
  }
}