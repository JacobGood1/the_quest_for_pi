part of component_server;

abstract class PlayerMovement implements Entity, Movement{
  List<String> keysBeingPressed = [];
  updatePlayerMovement (double dt) {
    print('werking ID $ID');
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

}

