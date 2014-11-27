part of server_entity;

abstract class Terrain extends Entity with Collision_AABB{
  Terrain(double x, double y):super(x,y){
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.add(updateCollisionAABB);
  }
}