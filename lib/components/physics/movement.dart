part of shared_component;

abstract class Movement implements SharedComponentData{
  void moveRight(){
    velocity.x = movementSpeed;
  }
  void moveLeft(){
    velocity.x = -movementSpeed;
  }
  void moveUp(){
    velocity.y = -movementSpeed;
  }
  void moveDown(){
    velocity.y = movementSpeed;
  }

  _updateMovement(num dt){
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }
}