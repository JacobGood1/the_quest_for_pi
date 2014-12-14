part of client_entity;

class Goblin extends Entity with GoblinAnimation, FootStep, HealthBar{
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
}