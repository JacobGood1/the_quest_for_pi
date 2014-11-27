part of server_entity;

class Player extends Entity with PlayerMovement, Movement{
  Player(x, y):super('black_mage',x,y) {
    movementSpeed = 100.0;
  }
}