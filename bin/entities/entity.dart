library server_entity;

import 'dart:mirrors';
import '../globals.dart';
import '../components/component.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert' show JSON;
import '../game_world/game_world.dart';

//flying creatures
part '../entities/flying_creatures/flying_creature.dart';
part '../entities/flying_creatures/bat.dart';

//player
part 'player.dart';

//terrain
part 'terrain/terrain.dart';
part 'terrain/bush.dart';

final RegExp init = new RegExp(r"\_init[A-Z][a-z]*");
final RegExp update = new RegExp(r"\_update[A-Z][a-z]*");
final RegExp collision = new RegExp(r"\_collision[A-Z][a-z]*");

Uuid uuid = new Uuid();

abstract class BaseEntity{
  List<Function> componentInitFunctionList = [],
                 componentUpdateFunctionList = [],
                 componentCollisionCheckFunctionList = [];

  double movementSpeed,  //TODO travis fix the scaling so that the entity may be the correct size on the client and the server
  size = 64.0;

  bool isColliding = false, _hasBeenInvoked = false;
  Set collidingWith = new Set();

  Vector velocity = new Vector(0.0,0.0),
  position;

  String ID, type;
  void initAllComponents(){
    for(var i = 0; i < componentInitFunctionList.length; i++){
      componentInitFunctionList[i]();
    }
  }
  updateAllComponents(num time){
    //this should be invoked every frame in the game loop
    //Update
    for(var i = 0; i < componentUpdateFunctionList.length; i++){
      componentUpdateFunctionList[i](time);
    }
    //Check Collisions
    for(var i = 0; i < componentCollisionCheckFunctionList.length; i++){
      componentCollisionCheckFunctionList[i](time);
    }
    updatePositionsClient();
  }
  void updatePositionsClient(){}

  BaseEntity attachEntity(){
    entityManager.add(this);
    return this;
  }

  BaseEntity detachEntity(){
    entityManager.remove(this);
    return this;
  }
  get entityManager => GameWorld.entityManager;
  Map toJson(){
    return {'ID': this.ID, 'positionX': this.position.x, 'positionY': this.position.y, 'type': this.type};
  }
}

//TODO assets might be messed up so remember to check for errors

abstract class Entity extends BaseEntity {
  Entity(double x, double y) {
    position = new Vector(x,y);
    ID = uuid.v4();
  }
}


