part of component;

abstract class PlayerMovement implements PlayerComponentData {
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
      webSocket.send(JSON.encode({'client' : 'd'}));
    }
    else {
      velocity = new Vector(0.0, 0.0);
    }
  }
}

