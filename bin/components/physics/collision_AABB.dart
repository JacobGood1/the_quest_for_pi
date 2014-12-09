part of server_component;

abstract class Collision_AABB implements Entity{
  Rectangle collider = new Rectangle(0.0, 0.0, 0.0, 0.0);
  double direction_x = 0.0;
  double direction_y = 0.0;
  double lastPosition_x, lastPosition_y;
  initCollisionAABB(){
    collider = new Rectangle(position.x, position.y, size, size);
  }
  updateCollisionAABB(time){
    if(this is Goblin){
      if(position.x.isNaN || position.y.isNaN){  //HACK
        position.x = lastPosition_x;
        position.y = lastPosition_y;
      }
    }
    this.collider = new Rectangle(position.x, position.y, size, size);
  }

  Point checkCollision(){
    //clear current collisions
    this.collidingWith.clear();

    //check travel direction
    if (lastPosition_x == position.x){
      //
    } else if (lastPosition_x < position.x) {
      direction_x = -1.0;
    } else {direction_x = 1.0;}

    if (lastPosition_y == position.y) {
      //
    }
    else if (lastPosition_y < position.y){
      direction_y = -1.0;
    } else {direction_y = 1.0;}

    //collision detection
    //loop through all available entities within the map.
    Rectangle intersection;
    Rectangle updatePlacement = new Rectangle(position.x, lastPosition_y, size, size);
    double dx = 0.0;
    double dy = 0.0;
    //set isColliding to false, if no collisions are found, then this will stay false
    isColliding = false;
    if(!(this is Player) && !(this is Bush)){
      GameWorld.playerEntities.forEach((Player player) {
        if (updatePlacement.intersects(player.collider)) {
          inCombat = true;
          player.inCombat = true;
        }
        else{
          inCombat = false;
        }
      });
    }

    entityManager.forEach((e){ //SharedEntity.entityManager.forEach  //TODO Travis this code is only handling entities and not players
      //print(this.distance2(e.collider));

        if(e is Bush){
          if (e != this) {
            //check x axis collision first
            if (updatePlacement.intersects(e.collider)) {
              //collision found, set isColliding to true
              isColliding = true;
              //grab the rectangle that describes the intersection
              intersection = updatePlacement.intersection(e.collider);
              //an intersection of 0.0 still counts as a collision, we must be careful with this rule when dealing with the displacement vector
              if (intersection.height == 0.0) {
                collidingWith.add(e);
              } else {
                dx += intersection.width * direction_x;
                updatePlacement = new Rectangle(position.x + dx, lastPosition_y, size, size);
                collidingWith.add(e);
              }
            }
          }
        }


    });

    updatePlacement = new Rectangle(updatePlacement.topLeft.x, position.y, size, size);//position.x + dx



    entityManager.forEach((e) {
      //SharedEntity.entityManager.forEach
      //print(this.distance2(e.collider));

        if(e.type == 'Bush'){
          if (e != this) {
            //check y axis collision second
            if (updatePlacement.intersects(e.collider)) {
              //collision found, set isColliding to true
              isColliding = true;
              //grab the rectangle that describes the intersection
              intersection = updatePlacement.intersection(e.collider);
              //an intersection of 0.0 still counts as a collision, we must be careful with this rule when dealing with the displacement vector
              //there is an identical check for 0.0 value happening in the X axis collision, scroll up to read it's comment and learn why this check is in place.
              if (intersection.width == 0.0) {
                //updatePlacement = new Rectangle(position.x, position.y, size, size);
                //dy = 0.0;
                collidingWith.add(e);
              } else {
                //collision is found, but we don't have any other 'axis' to check. we no longer need to use the 'updatePlacement' rectangle.
                //set dy to the displacement value and we're done.
                dy += intersection.height * direction_y;
                updatePlacement = new Rectangle(updatePlacement.topLeft.x, position.y + dy, size, size);
                collidingWith.add(e);
              }
            } else {
              //no y axis collision was found
            }
          }
        }

    });


    if(intersection != null){
      //we have constructed our displacement values, now let's return them as a vector.
      return new Point(dx, dy);
    }

    //everything else failed, return a displacement of 0.0, no collisions were detected.
    return new Point(0.0, 0.0);
  }

  double distance2(Rectangle otherCollider){
    /*
    this distance fn is only used for finding the distance between 2 colliders and efficiently as possible.
    the actual distance found will not be accurate and should not be used in other circumstances.
    this is for finding whether a.collider is closer to b.collider than c.collider.
     */

    double thisX = collider.topLeft.x;
    double thisY = collider.topLeft.y;

    double otherX = otherCollider.topLeft.x;
    double otherY = otherCollider.topLeft.y;

    double x = thisX - otherX,
           y = thisY - otherY;

    return (x * x) + (y * y);
  }
}