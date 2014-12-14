part of server_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB, WalkingAnimation, FootStep, HealthBar, Combat{
  String currentKey = '';
  List<String> currentActiveKeys = [];
  Map _keyDecipher = new Map.fromIterables(new List.generate(26, (int index) => index + 65), "abcdefghijklmnopqrstuvwxyz".split(""));
  Map<String,bool> keysPressed = {'d': false, 'w': false, 'a': false, 's': false};

  Player(x, y):super(x,y) {
    componentInitFunctionList.addAll([initCollisionAABB, initWalkingAnimation, initCombat]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement, updatePlayerMovement,updateCollisionAABB, updateInputProcessor, updateWalkingAnimation, updateFootStep]);
    movementSpeed = 300.0;
    type = 'Player';
  }

  updateInputProcessor(double dt){
    if(isAnyKeyDown()){
      currentKey = currentActiveKeys.last;
    }
    else{
      currentKey = '';
    }
  }
  bool isKeyBeingPressed(String key){
    if(currentActiveKeys.isNotEmpty){
      return currentActiveKeys.contains(key);
    }
    return false;
  }
  bool isTheLastKeyHeld(String key){
    return currentKey == key;
  }

  bool areAnyOfTheseKeysActive(List<String> keys){
    for(var key in keys){
      if(currentActiveKeys.contains(key)){
        return true;
      }
    }
    return false;
  }

  bool isAnyKeyDown(){
    return currentActiveKeys.isNotEmpty;
  }
}