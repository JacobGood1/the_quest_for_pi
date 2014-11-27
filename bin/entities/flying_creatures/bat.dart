part of server_entity;

class Bat extends FlyingCreature{
  Bat (double x, double y) : super (x,y){
    movementSpeed = 50.0;
    type = 'Bat';
  }
}