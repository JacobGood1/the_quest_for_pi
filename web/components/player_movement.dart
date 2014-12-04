part of client_component;

abstract class PlayerMovement implements Entity, Movement{
  updatePlayerMovement (double dt) {
    if(InputManager.isAnyKeyDown() != null){
      if(InputManager.isKeyBeingPressed('w')){
        moveUp();
      }
      else if(InputManager.isKeyBeingPressed('a')){
        moveLeft();
      }
      else if(InputManager.isKeyBeingPressed('s')){
          moveDown();
        }
        else if(InputManager.isKeyBeingPressed('d')){
            moveRight();
          }
          else {
            velocity = new Vector(0.0, 0.0);
          }
    }
  }

}

