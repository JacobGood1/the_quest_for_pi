part of server_component;

abstract class PlayerMovementData{
  bool isAnyKeyDown();
  bool isTheLastKeyHeld(String key);
  bool isKeyBeingPressed(String x);
  bool areAnyOfTheseKeysActive(List keys);
}

abstract class PlayerMovement implements Movement, PlayerMovementData{
  //bool aIsAlreadyPressed = false;
  updatePlayerMovement (double dt) {
    if(isAnyKeyDown()){
      if(isTheLastKeyHeld('w')){
        moveUp();
      }
      if(isTheLastKeyHeld('a')){
        moveLeft();
      }
      if(isTheLastKeyHeld('s')){
        moveDown();
      }
      if(isTheLastKeyHeld('d')){
        moveRight();
      }
      if(!areAnyOfTheseKeysActive(['a','d'])){
        velocity.x = 0.0;
      }
      if(!areAnyOfTheseKeysActive(['w','s'])){
        velocity.y = 0.0;
      }
    } else {
      velocity = new Vector(0.0, 0.0);
    }
  }
}

