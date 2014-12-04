part of client_entity;

class Bat extends FlyingCreature{

  Bat (String ID, double x, double y) : super ('Bat',x,y, ID){
    movementSpeed = 5.0;
  }

}