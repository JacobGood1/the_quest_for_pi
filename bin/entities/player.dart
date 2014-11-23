part of entity;

class Player extends Entity with PlayerMovement, Movement{
  String ID;
  Player(this.ID, x, y):super('black_mage',x,y) {
    movementSpeed = 100.0;
  }
}