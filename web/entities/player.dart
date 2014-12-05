part of client_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB, WizardAnimation, FootStep{
  Player(String ID, x, y, int animeFrame, String animeState, String soundState):super('Player',x,y, ID){
    componentInitFunctionList.addAll([initWizardAnimation]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateWizard, updateFootStep]);
    movementSpeed = 100.0;
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
    currentSoundState = soundState;
  }
}