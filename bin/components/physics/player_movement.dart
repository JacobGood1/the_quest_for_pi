part of server_component;

abstract class PlayerMovementData{
  bool isAnyKeyDown();
  bool isKeyBeingPressed(String x);
}

abstract class PlayerMovement implements Movement, PlayerMovementData{
  updatePlayerMovement (double dt) {
    if(isAnyKeyDown()){
      if(isKeyBeingPressed('w')){
        moveUp();
      } else if(isKeyBeingPressed('a')){
        moveLeft();
      } else if(isKeyBeingPressed('s')){
        moveDown();
      } else if(isKeyBeingPressed('d')){
        moveRight();
      } else {
        velocity = new Vector(0.0, 0.0);
      }
    } else {
      velocity = new Vector(0.0, 0.0);
    }
  }
}

