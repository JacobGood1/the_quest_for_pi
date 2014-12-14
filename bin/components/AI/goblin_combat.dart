part of server_component;

//TODO make this attacking specific to the goblin

//TODO get the goblin to attack every five seconds
//1 play an animation
//2 dec the health of the weakest wizard, if no weakest wiztard is found, hurt a random one

//handles animation and attacking for goblin
abstract class GoblinCombatAI implements HealthBar, Entity{
  bool _hasStartedGoblinCombatAI = false, _isGoblinAttackingGoblinCombatAI = false;
  double _goblinTimerGoblinCombatAI = 0.0, _goblinTimerAnimationGoblinCombatAI = 0.0;
  int _goblinAnimationFrameGoblinCombatAI = 0;


  initGoblinCombatAI(){
    //addToJson() //TODO gotta add goblins additional information to json to pass to the client
    componentCombatModeFunctionList.add(updateGoblinCombatAI);
  }

  void updateGoblinCombatAI(num time){
    if(this is Goblin){
      if(_goblinTimerGoblinCombatAI >= 5.0){
        _goblinTimerGoblinCombatAI = 0.0;
        _isGoblinAttackingGoblinCombatAI = true;
      } else{
        if(_isGoblinAttackingGoblinCombatAI){
          _goblinTimerAnimationGoblinCombatAI += time;
          if(_goblinTimerAnimationGoblinCombatAI >= 0.045){
            _goblinTimerAnimationGoblinCombatAI = 0.0;
            _goblinAnimationFrameGoblinCombatAI++;
          }
          if(_goblinAnimationFrameGoblinCombatAI == 7){
            _goblinAnimationFrameGoblinCombatAI = 0;
            _isGoblinAttackingGoblinCombatAI = false;
          }
        } else{
          _goblinTimerGoblinCombatAI+= time;
        }

      }
    }

  }
}