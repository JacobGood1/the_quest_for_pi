part of server_entity;

class Goblin extends Entity with Movement, Collision_AABB, SitStillRunToPlayerIfCloseOrStar, GoblinCombatAI,WalkingGoblinAnimation, SpaceOut, FootStep, HealthBar, Combat{

  Goblin(x,y, inWhatInstance):super(x,y){
    this.inWhatInstance = inWhatInstance;
    componentInitFunctionList.addAll([initCollisionAABB, initGoblinCombatAI, initHealthBar, initCombat]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateSitStillRunToPlayerIfClose,updateMovement,updateCollisionAABB, updateWalkingAnimation, updateSpaceOut, updateFootStep]);

    movementSpeed = 200.0;
    type = 'Goblin';
  }

  Map toJson(){
    return
      {
          'ID': this.ID,
          'positionX': this.position.x,
          'positionY': this.position.y,
          'type': this.type,
          'currentAnimationState': this.currentAnimationState,
          'currentAnimationFrame': this.currentAnimationFrame,
          'currentSoundState': this.currentSoundState,
          'isDead': this.isDead,
          'inCombat': this.inCombat,
          'health' : this.health
      };
  }

}