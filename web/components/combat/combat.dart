part of client_component;

abstract class Combat implements HealthBar, Entity{
  bool _combatIsStarted = false;

  initCombat(){
    componentCombatModeFunctionList.add(updateCombat);
  }

  void updateCombat(num time){
    if(this is Goblin){
      print('goblin fighting');
    } else if(this is Player && this.inCombat){
      if(!_combatIsStarted){
        _combatIsStarted = true;
        stage.removeChildren(0, stage.numChildren - 1);

      }
    }



  }

  void leaveCombat(){

  }
}