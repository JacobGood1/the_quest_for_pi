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
    //print("$this $isColliding");
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

    /*

    //construct a new list which contains all the collidable entities, then sort that list
    //based on distance from THIS
    var entityListCopy = [];
    entityListCopy.addAll(SharedEntity.entityManager);
    var collidable;
    var collidables = [];

    double d;
    entityListCopy.forEach((e){
      if (e != this){
        if (d == null) {
          d = this.distance2(e.collider);
          collidable = e;
        } else {
          var x = this.distance2(e.collider);
          if(x < d){
            d = x;
            collidable = e;
          } else if (x == d){
            collidables.add(e);
          }
        }
      }

    });

    collidables.add(collidable);

    //print(collidables.length);

    */

    /*
    collidables.sort((SharedEntity x, SharedEntity y){

    });
    */

    entityManager.forEach((e){ //SharedEntity.entityManager.forEach  //TODO Travis this code is only handling entities and not players
      //print(this.distance2(e.collider));
      if (e != this) {
        //check x axis collision first
        if (updatePlacement.intersects(e.collider)) {
          //collision found, set isColliding to true
          isColliding = true;
          //grab the rectangle that describes the intersection
          intersection = updatePlacement.intersection(e.collider);
          //an intersection of 0.0 still counts as a collision, we must be careful with this rule when dealing with the displacement vector
          if (intersection.height == 0.0) {
            //there IS an intersection happening, but in a '0,0' situation, we don't want to respond from the collision.
            //continue to move in the desired direction and don't resolve any collision
            //notice we check '0.0' from the height. When the entity's top or bottom is touching the other collider,
            //the intersection height is 0.0, while the width will be some large number. if this check was not in place,
            //it will cause the entity to translate left or right when touching the bottom or top of another collider.
            //this turns out to be a y axis collision check in disguise.

            //updatePlacement = new Rectangle(position.x, lastPosition_y, size, size);
            //dx = 0.0;
            collidingWith.add(e);
          } else {
            //we have real collision happening, we need to respond by taking the width of the intersection rectangle.
            //this will become the displacement value... however, this value is ALWAYS positive, so we must also
            //multiply it by the direction value. this will give us either a positive or negative displacement value.
            //we then add that to the current position.x value which in turn will be the x value within the newly
            //created rectangle (updatePlacement). this new rectangle describes where the entity should be after
            //checking for collisions on the X axis only. we then insert position.y as the y value of the rectangle.
            //remember.. position.x and .y have already been updated with their new position from the entities velocity.
            //so these values already describe the most 'up-to-date' position of the entity. now we are simply checking
            //if these new positions are valid, and if not, we return a new vector to 'push' the collider away.
            //dx is the x compoenent of that vector.
            dx += intersection.width * direction_x;
            updatePlacement = new Rectangle(position.x + dx, lastPosition_y, size, size);
            collidingWith.add(e);
          }
        } else {
          //no x axis collision was found, create a new rectangle with the most 'up-to-date' position values and then
          //check for y axis collision.
          //updatePlacement = new Rectangle(position.x, lastPosition_y, size, size);
        }

      }
    });

    //updatePlacement.topLeft.x
    updatePlacement = new Rectangle(updatePlacement.topLeft.x, position.y, size, size);//position.x + dx



    entityManager.forEach((e) {
      //SharedEntity.entityManager.forEach
      //print(this.distance2(e.collider));
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