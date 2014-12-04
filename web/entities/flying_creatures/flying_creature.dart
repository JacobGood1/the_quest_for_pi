part of client_entity;


abstract class FlyingCreature extends Entity with Movement, Collision_AABB{
  int hp;
  FlyingCreature(String type, double x, double y, String ID):super(type,x, y, ID){
    componentInitFunctionList.addAll([initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement, updateCollisionAABB]);
  }
}