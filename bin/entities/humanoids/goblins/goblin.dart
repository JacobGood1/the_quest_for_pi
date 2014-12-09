part of server_entity;

class Goblin extends Entity with Movement, Collision_AABB, SitStillRunToPlayerIfClose, WalkingGoblinAnimation, SpaceOut, FootStep, HealthBar{
  Goblin(x,y):super(x,y){
    componentInitFunctionList.addAll([initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateSitStillRunToPlayerIfClose,updateMovement,updateCollisionAABB, updateWalkingAnimation, updateSpaceOut, updateFootStep]);

    movementSpeed = 200.0;
    type = 'Goblin';
  }



}