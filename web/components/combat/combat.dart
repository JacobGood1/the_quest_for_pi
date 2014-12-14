part of client_component;
//TODO WATCH THE EFF OUT FOR CRAP LIKE THIS
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