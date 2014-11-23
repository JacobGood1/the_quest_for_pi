part of entity;

class Player extends Entity with PlayerMovement, Movement, InputManager, Collision_AABB {
  String ID;
  Player(this.ID, x, y):super('player',x,y) {
    movementSpeed = 300.0;
  }

  _updatePlayer(double time){
    collidingWith.forEach((e){
      if(e is Bat){

      }
    });
  }
}