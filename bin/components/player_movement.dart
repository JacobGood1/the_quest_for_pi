part of component;

abstract class PlayerMovement implements SharedEntity, Movement{
  List<String> keysBeingPressed = [];
  _updatePlayerMovement (double dt) {
    if(isKeyBeingPressed('w')){
      moveUp();
    }
    else if(isKeyBeingPressed('a')){
      moveLeft();
    }
    else if(isKeyBeingPressed('s')){
      moveDown();
    }
    else if(isKeyBeingPressed('d')){
      moveRight();
    }
    else {
      velocity = new Vector(0.0, 0.0);
    }
  }

  bool isKeyBeingPressed(String key){
    if(!keysBeingPressed.isEmpty){
      return key == keysBeingPressed.last;
    }
    return false;
  }

  void currentKeys(List<String> keys){
    keysBeingPressed = keys;
  }

}

