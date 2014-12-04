part of client_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB, WizardAnimation{
  Player(String ID, x, y, int animeFrame, String animeState):super('Player',x,y, ID){
    componentInitFunctionList.addAll([initWizardAnimation]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateWizard]);
    movementSpeed = 100.0;
    type = 'Player';
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
  }
}