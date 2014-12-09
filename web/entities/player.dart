part of client_entity;

class Player extends Entity with WizardAnimation, FootStep, Combat, HealthBar{
  Player(String ID, x, y, int animeFrame, String animeState, String soundState):super('Player',x,y, ID){
    componentInitFunctionList.addAll([initWizardAnimation, initCombat]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateWizard, updateFootStep]);
    movementSpeed = 100.0;
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
    currentSoundState = soundState;
  }
}