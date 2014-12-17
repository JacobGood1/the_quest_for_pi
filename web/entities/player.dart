part of client_entity;

class Player extends Entity with WizardAnimation, FootStep, Combat, HealthBar{
  String currentProblem, problemSolution;
  int spellReserve = 0;
  Player(String ID, double x, double y, int animeFrame, String animeState, String soundState):super('Player',x,y, ID){
    componentInitFunctionList.addAll([initWizardAnimation, initCombat]);
    initAllComponents();
    componentCombatModeFunctionList.addAll([updateWizard]);
    componentUpdateFunctionList.addAll([updateWizard, updateFootStep]);

    movementSpeed = 100.0;
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
    currentSoundState = soundState;
  }
  void _debug(num time){
    if(this.ID == ID){
      print(currentProblem);
    }

  }
  calcCurrentMana(){ //could return null, handle this on the combat server
    if(this.ID == main.ID){
      return 'Mana: ${this.spellReserve}';
    }
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
      ..health = entity['health']
      ..currentProblem = entity['currentProblem']
      ..problemSolution = entity['problemSolution']
      ..spellReserve = entity['spellReserve'];
  }
}