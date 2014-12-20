part of server_component;



//handles animation and attacking for goblin
abstract class GoblinCombatAI implements HealthBar, Entity{
  bool _hasStartedGoblinCombatAI = false, isGoblinAttackingGoblinCombatAI = false;
  double _goblinTimerGoblinCombatAI = 0.0, _goblinTimerAnimationGoblinCombatAI = 0.0;
  double _attackSpeedGoblinCombatAI = 10.0;

  initGoblinCombatAI(){
    componentCombatModeFunctionList.add(updateGoblinCombatAI);
  }

  void updateGoblinCombatAI(num time){
    if(_goblinTimerGoblinCombatAI >= _attackSpeedGoblinCombatAI){
      _goblinTimerGoblinCombatAI = 0.0;
      isGoblinAttackingGoblinCombatAI = true;
    } else{
      if(isGoblinAttackingGoblinCombatAI){
        currentAnimationState = AnimationStates.ATTACKING;
        _goblinTimerAnimationGoblinCombatAI += time;
        if(_goblinTimerAnimationGoblinCombatAI >= 0.060){
          _goblinTimerAnimationGoblinCombatAI = 0.0;
          currentAnimationFrame++;
          if(currentAnimationFrame == 9){
            currentAnimationFrame = 0;
            Player weakestPlayer = inWhatInstance.playerEntities.first;
            inWhatInstance.playerEntities.forEach((Player player) {
              if(player.health <= weakestPlayer.health){
                weakestPlayer = player;
              }
            });
            weakestPlayer.reduceHealth(10);
            isGoblinAttackingGoblinCombatAI = false;
          }
        }

      } else{
        _goblinTimerGoblinCombatAI+= time;
      }

    }
  }
}