part of client_component;

abstract class HealthBar implements Entity{
  double _healthBarPositionX = 0.0, _healthBarPositionY = 0.0;
  int health = 100;
  increaseHealth(int howMuch) {
    health += howMuch;
    if (health >= 100) {
      health = 100;
    }
  }
  reduceHealth(int howMuch){
    health -= howMuch;
    if (health >= 0) {
      health = 0;
    }
  }

  updateHealthBar(num time){
    _healthBarPositionX = position.x; _healthBarPositionY = position.y;
  }
}