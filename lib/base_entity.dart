library base_entity;


import 'globals.dart';


abstract class BaseEntity{
  List<Function> componentInitFunctionList = [],
                 componentUpdateFunctionList = [],
                 componentInstanceInitFunctionList = [],
                 componentCombatModeFunctionList = [],
                 componentCollisionCheckFunctionList = [];

  List additionalJSONInformation = [];
  double movementSpeed,
  size = 64.0;
  var inWhatInstance;
  bool isColliding = false, _hasBeenInvoked = false, hasChangedSinceLastInvocation = false, isDead = false, inCombat = false, inInstance = false;
  Set collidingWith = new Set();

  Vector velocity = new Vector(0.0,0.0),
  position;

  int currentAnimationFrame = 0;
  String ID, type, currentAnimationState = '', currentSoundState = '';
  void initAllComponents(){
    for(var i = 0; i < componentInitFunctionList.length; i++){
      componentInitFunctionList[i]();
    }
    for(var i = 0; i < componentInstanceInitFunctionList.length; i++){
      componentInstanceInitFunctionList[i]();
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

  void updateAllCombatModeComponents(num time){
    for(var i = 0; i < componentCombatModeFunctionList.length; i++){
      componentCombatModeFunctionList[i](time);
    }
  }

  void updatePositionsClient(){}
}




