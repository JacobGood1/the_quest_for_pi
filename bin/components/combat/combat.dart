part of server_component;


abstract class Combat implements HealthBar, Entity{
  initCombat(){
    componentCombatModeFunctionList.add(_updateCombat);
  }
  _updateCombat(num time){
    if(health <= 0){
      this.isDead = true;
      componentCollisionCheckFunctionList.clear();

    }
  }
}