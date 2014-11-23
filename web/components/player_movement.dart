part of component;

abstract class PlayerMovement implements PlayerComponentData, SharedMovementData {
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
      //webSocketSend({'client' : 'd'});
    }
    else {
      velocity = new Vector(0.0, 0.0);
    }
  }
}

