part of entity;

class BlackMage extends Entity with PlayerMovement, Movement, InputManager {

  BlackMage(x,y):super('black_mage',x,y) {
    movementSpeed = 100.0;
  }
}

