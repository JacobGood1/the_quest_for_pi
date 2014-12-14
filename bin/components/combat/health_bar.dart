part of server_component;


abstract class HealthBar implements Entity{
  int health = 100;


  initHealthBar(){
    addToJson(['health',health]);
  }

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
}