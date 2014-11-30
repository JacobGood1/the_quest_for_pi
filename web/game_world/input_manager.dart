library input_manager;

class InputManager {
  static String currentKey = '';
  static Set<String> currentActiveKeys = new Set();
  static Map _keyDecipher = new Map.fromIterables(new List.generate(26, (int index) => index + 65), "abcdefghijklmnopqrstuvwxyz".split(""));
  static Map<String,bool> keysPressed = {'d': false, 'w': false, 'a': false, 's': false};

  InputManager(var stage){
    stage.onKeyDown.listen((e) {
      keysPressed[_keyDecipher[e.keyCode]] = true;
      currentActiveKeys.add(_keyDecipher[e.keyCode]);
    });
    stage.onKeyUp.listen((e) {
      keysPressed[_keyDecipher[e.keyCode]] = false;
      currentActiveKeys.remove(_keyDecipher[e.keyCode]);
    });
  }

  static updateInputProcessor(double dt){
    if(isAnyKeyDown()){
      currentKey = currentActiveKeys.last;
    }
    else{
      currentKey = '';
    }
  }

  static bool isKeyBeingPressed(String key){
    return currentKey == key;
  }

  static bool areAnyOfTheseKeysActive(List<String> keys){
    for(var key in keys){
      if(keysPressed[key]){
        return true;
      }
    }
    return false;
  }
  static bool isAnyKeyDown(){
    return !currentActiveKeys.isEmpty;
  }
}

