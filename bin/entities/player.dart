part of server_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB{
  Player(x, y):super(x,y) {
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement, updatePlayerMovement,updateCollisionAABB]);
    movementSpeed = 100.0;
    type = 'Player';
  }
}