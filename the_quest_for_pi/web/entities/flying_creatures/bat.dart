part of entity;

class Bat extends FlyingCreature{

  Bat (double x, double y) : super ('bat',x,y){
    scaleX = 0.5;
    scaleY = 0.5;
    movementSpeed = 100.0;
  }

}