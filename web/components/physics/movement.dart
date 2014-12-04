part of client_component;

abstract class Movement implements Entity, Collision_AABB{
  double lastPosition_x;
  double lastPosition_y;
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

  updateMovement(num dt){
    //store last position
    lastPosition_x = position.x;
    lastPosition_y = position.y;

    Point displacementVector;
    //update x based on velocity
    position.x += velocity.x * dt;
    //update y based on velocity
    position.y += velocity.y * dt;

    //check collision
    displacementVector = checkCollision();//new Point(velocity.x * dt, this.position.y)

    //update x based on collision
    position.x += displacementVector.x;
    //update y based on collision
    position.y += displacementVector.y;
  }
}