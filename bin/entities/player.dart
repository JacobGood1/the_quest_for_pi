part of server_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB, WizardAnimation{
  String currentKey = '';
  List<String> currentActiveKeys = [];
  Map _keyDecipher = new Map.fromIterables(new List.generate(26, (int index) => index + 65), "abcdefghijklmnopqrstuvwxyz".split(""));
  Map<String,bool> keysPressed = {'d': false, 'w': false, 'a': false, 's': false};

  Player(x, y):super(x,y) {
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement, updatePlayerMovement,updateCollisionAABB, updateInputProcessor, updateWizardAnimation]);
    movementSpeed = 100.0;
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
    return currentKey == key;
  }

  bool areAnyOfTheseKeysActive(List<String> keys){
    for(var key in keys){
      if(keysPressed[key]){
        return true;
      }
    }
    return false;
  }
  bool isAnyKeyDown(){
    return currentActiveKeys.isNotEmpty;
  }
}