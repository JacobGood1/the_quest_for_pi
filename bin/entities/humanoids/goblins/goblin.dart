part of server_entity;

class Goblin extends Entity with Movement, Collision_AABB, SitStillRunToPlayerIfClose{
  Goblin(x,y):super(x,y){
    componentInitFunctionList.addAll([initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateSitStillRunToPlayerIfClose,updateMovement,updateCollisionAABB]);
    movementSpeed = 25.0;
    type = 'Goblin';
  }
}