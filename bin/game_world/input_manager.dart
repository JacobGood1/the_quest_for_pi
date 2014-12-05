library input_manager;

abstract class InputManager {
  String currentKey = '';
  List<String> currentActiveKeys = [];
  Map _keyDecipher = new Map.fromIterables(new List.generate(26, (int index) => index + 65), "abcdefghijklmnopqrstuvwxyz".split(""));
  Map<String,bool> keysPressed = {'d': false, 'w': false, 'a': false, 's': false};


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

