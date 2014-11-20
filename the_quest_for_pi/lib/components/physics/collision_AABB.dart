part of shared_component;

abstract class Collision_AABB implements SharedComponentData{
  double size;
  double collision_x;
  double collision_y;
  Rectangle collider = new Rectangle(0.0, 0.0, 32.0, 32.0);

  _initCollisionAABB(){
    size = 32.0;
    collision_x = position.x;
    collision_y = position.y;
  }
  _updateCollisionAABB(time){
    this.collider = new Rectangle(position.x, position.y, size, size);
  }

  void checkCollision(Point displacementVector, other){
    Rectangle intersection;
    if (collider.intersects(other.collider)) {
      intersection = collider.intersection(other.collider);
    } else {
      intersection = new Rectangle(collision_x, collision_y, 0.0, 0.0);
    }
    //resolve x
    if(displacementVector.y == 0.0){
      collider = resolveCollisionX(intersection);
    } else { //resolve y
      collider = resolveCollisionY(intersection);
    }

  }

  Rectangle resolveCollisionX(Rectangle displacementRectangle){
    Point displacementVector = new Point (displacementRectangle.width,
                                    displacementRectangle.height);
    return new Rectangle(collision_x + displacementVector.x, 0.0, size, size);
  }
  Rectangle resolveCollisionY(Rectangle displacementRectangle){
    Point displacementVector = new Point (displacementRectangle.width,
    displacementRectangle.height);
    return new Rectangle(0.0, collision_y + displacementVector.y, size, size);
  }
}