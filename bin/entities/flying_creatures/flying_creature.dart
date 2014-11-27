part of server_entity;


abstract class FlyingCreature extends Entity with ErraticFly, Movement, Collision_AABB{
  int hp;
  FlyingCreature(double x, double y):super(x, y){
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateErraticFly, updateMovement, updateCollisionAABB]);
  }
}