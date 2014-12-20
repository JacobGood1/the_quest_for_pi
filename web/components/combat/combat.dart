part of client_component;

abstract class Combat implements HealthBar, Entity{
  bool _combatIsStarted = false;
  initCombat(){
    componentCombatModeFunctionList.add(updateCombat);
  }

  void updateCombat(num time) {
    if (this is Goblin) {
      if(this.health == 0){
        this.isDead;
      }
    }
  }
}