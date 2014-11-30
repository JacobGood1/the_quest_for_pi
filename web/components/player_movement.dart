part of client_component;

abstract class PlayerMovement implements Entity, Movement{
  List<String> keysBeingPressed = [];
  String ID;
  _updatePlayerMovement (double dt) {
    //keysBeingPressed = clientInput[ID];
    if(keysBeingPressed != null){
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

