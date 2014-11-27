part of client_entity;


abstract class FlyingCreature extends Entity with Movement, Collision_AABB{
  int hp;
  FlyingCreature(String type, double x, double y):super(type,x, y){
    componentInitFunctionList.addAll([initMovement, initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement, updateCollisionAABB]);
  }
}