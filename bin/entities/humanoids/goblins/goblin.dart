part of server_entity;

class Goblin extends Entity with Movement, Collision_AABB, SitStillRunToPlayerIfCloseOrStar, GoblinCombatAI,WalkingGoblinAnimation, SpaceOut, FootStep, HealthBar{

  Goblin(x,y, inWhatInstance):super(x,y){
    this.inWhatInstance = inWhatInstance;
    componentInitFunctionList.addAll([initCollisionAABB, initGoblinCombatAI, initHealthBar]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateSitStillRunToPlayerIfClose,updateMovement,updateCollisionAABB, updateWalkingAnimation, updateSpaceOut, updateFootStep]);

    movementSpeed = 200.0;
    type = 'Goblin';
  }



}