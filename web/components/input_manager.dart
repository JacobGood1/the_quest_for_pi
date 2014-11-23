part of component;



abstract class InputManager implements ComponentData {
  String currentKey = '';
  Set<String> currentActiveKeys = new Set();
  Map _keyDecipher;

  Map<String,bool> keysPressed = {'d': false, 'w': false, 'a': false, 's': false};
  _initInputManager(){
    _keyDecipher = new Map.fromIterables(new List.generate(26, (int index) => index + 65), "abcdefghijklmnopqrstuvwxyz".split(""));
    stage.onKeyDown.listen((e) {
      keysPressed[_keyDecipher[e.keyCode]] = true;
      currentActiveKeys.add(_keyDecipher[e.keyCode]);
      currentClientKeys = currentActiveKeys.toList();
    });
    stage.onKeyUp.listen((e) {
      keysPressed[_keyDecipher[e.keyCode]] = false;
      currentActiveKeys.remove(_keyDecipher[e.keyCode]);
      currentClientKeys = currentActiveKeys.toList();
    });

  }

  _updateInputProcessor(double dt){
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
    return !currentActiveKeys.isEmpty;
  }
}

