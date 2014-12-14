part of server_component;

abstract class Combat implements HealthBar, Entity{
  bool _hasCombatStarted = false;

  initCombat(){
    componentCombatModeFunctionList.add(updateCombat);
  }

  void updateCombat(num time){
    if(!_hasCombatStarted){
      _hasCombatStarted = true;
    }

  }
}