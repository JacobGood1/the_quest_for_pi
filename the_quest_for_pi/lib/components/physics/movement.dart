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
    //update x based on velocity
    position.x += velocity.x * dt;
    //check collision with the x axis

    SharedEntity.entityManager.forEach((e){
      if (e != this) {
        checkCollision( new Point(velocity.x * dt, 0.0), e);
      }
    });
    //update x based on collision
    position.x = collider.topLeft.x;

    //update y based on velocity
    position.y += velocity.y * dt;
    //check collision with the y axis
    SharedEntity.entityManager.forEach((e) {
      if (e != this) {
        checkCollision(new Point(0.0, velocity.y * dt), e);
      }
    });
    //update y based on collision
    position.y = collider.topLeft.y;
  }
}