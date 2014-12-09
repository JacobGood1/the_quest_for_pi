part of client_entity;

class Goblin extends Entity with GoblinAnimation, FootStep{
  Goblin(String ID, x, y, int animeFrame, String animeState, String soundState):super('Goblin',x,y, ID) {
    componentInitFunctionList.addAll([initGoblinAnimation]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateGoblinAnimation]);
    movementSpeed = 100.0;
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
    currentSoundState = soundState;
  }
}