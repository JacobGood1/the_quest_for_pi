part of client_component;

abstract class Combat implements HealthBar, Entity{
  bool _combatIsStarted = false;
  initCombat(){
    componentCombatModeFunctionList.add(updateCombat);
  }

  void updateCombat(num time){

    if(inCombat) {

    }


  void leaveCombat(){

  }
  }
}