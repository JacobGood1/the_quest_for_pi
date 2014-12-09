part of server_component;

abstract class Combat implements HealthBar{
  bool _hasCombatStarted = false;
  initCombat(){
    componentCombatModeFunctionList.add(updateCombat);
  }

  void updateCombat(num time){

  }
}