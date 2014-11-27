library client_entity;

import '../../bin/entities/entity.dart' as e show BaseEntity;
import 'package:stagexl/stagexl.dart' show Sprite, Bitmap;
import 'dart:mirrors';
import '../components/component.dart';
import '../../bin/globals.dart' as g;
//import '../entities/entity.dart' as client;
import '../game_world/game_world.dart';

//terrian
part 'terrain/terrain.dart';
part 'terrain/bush.dart';

//flying creatures
part 'flying_creatures/flying_creature.dart';
part 'flying_creatures/bat.dart';

abstract class Entity extends Sprite with e.BaseEntity{  //must be instantiated after the resource manager is done loading!
  Entity(String type, double posX, double posY){
    position = new g.Vector(posX, posY);
    initAllComponents();
    x = position.x;
    y = position.y;
    this.type = type;
    addChild(new Bitmap(GameWorld.resourceManager.getBitmapData(type)));
  }
  @override
  void updatePositionsClient(){
    this..x = position.x ..y = position.y;
  }
}