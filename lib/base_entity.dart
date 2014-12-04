library base_entity;


import 'globals.dart';
import 'package:uuid/uuid.dart';



Uuid uuid = new Uuid();

abstract class BaseEntity{
  List<Function> componentInitFunctionList = [],
                 componentUpdateFunctionList = [],
                 componentCollisionCheckFunctionList = [];
  double movementSpeed,
  size = 64.0;

  bool isColliding = false, _hasBeenInvoked = false, hasChangedSinceLastInvocation = false, hasDied = false;
  Set collidingWith = new Set();

  Vector velocity = new Vector(0.0,0.0),
  position;

  int currentAnimationFrame = 0;

  String ID, type, currentAnimationState = '';
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

  Map toJson(){
    return{
        'ID': this.ID,
        'positionX': this.position.x,
        'positionY': this.position.y,
        'type': this.type,
        'currentAnimationState': this.currentAnimationState,
        'currentAnimationFrame': this.currentAnimationFrame
    };
  }
}




