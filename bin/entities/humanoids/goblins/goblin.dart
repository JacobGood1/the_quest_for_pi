part of server_entity;

class Goblin extends Entity with Movement, Collision_AABB, SitStillRunToPlayerIfCloseOrStar, WalkingGoblinAnimation, SpaceOut, FootStep, HealthBar, Combat{
  Goblin(x,y):super(x,y){
    componentInitFunctionList.addAll([initCollisionAABB, initCombat]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateSitStillRunToPlayerIfClose,updateMovement,updateCollisionAABB, updateWalkingAnimation, updateSpaceOut, updateFootStep]);

    movementSpeed = 200.0;
    type = 'Goblin';
  }



}