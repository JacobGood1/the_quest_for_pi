part of server_component;

abstract class Movement implements Collision_AABB{
  double lastPosition_x;
  double lastPosition_y;
  void moveRight(){
    velocity.x = movementSpeed;
  }
  void moveLeft(){
    velocity.x = -movementSpeed;
  }
  void moveUp([double speed]){
    if(speed == null){
      velocity.y = -movementSpeed;
    } else{
      velocity.y = -speed;
    }
  }
  void moveDown(){
    velocity.y = movementSpeed;
  }
  void moveToward(Entity other){
    velocity = (other.position - this.position).normalize() * movementSpeed;
  }
  void moveAway(Entity other){
    velocity = (other.position - this.position).normalize() * -movementSpeed;
  }
  void stopMoving(){
    velocity = new Vector(0.0,0.0);
  }

  updateMovement(num dt){
    if(lastPosition_x != position.x || lastPosition_y != position.y){
      hasChangedSinceLastInvocation = true;
    } else{
      hasChangedSinceLastInvocation = false;
    }
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