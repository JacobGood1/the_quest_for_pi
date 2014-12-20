part of client_entity;

class Goblin extends Entity with GoblinAnimation, FootStep, HealthBar, Combat{
  Goblin(String ID, x, y, int animeFrame, String animeState, String soundState):super('Goblin',x,y, ID) {
    componentInitFunctionList.addAll([initGoblinAnimation]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateGoblinAnimation]);
    componentCombatModeFunctionList.addAll([updateGoblinAnimation]);
    movementSpeed = 100.0;
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
    currentSoundState = soundState;
  }

  void extractData(Map entity){
    this
      ..ID = entity['ID']
      ..position.x = entity['positionX']
      ..position.y = entity['positionY']
      ..currentAnimationFrame = entity['currentAnimationFrame']
      ..currentAnimationState = entity['currentAnimationState']
      ..currentSoundState = entity['currentSoundState']
      ..isDead = entity['isDead']
      ..inCombat = entity['inCombat']
      ..health = entity['health'];
  }
}