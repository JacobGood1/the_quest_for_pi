part of client_entity;

abstract class Terrain extends Entity with Collision_AABB{
  Terrain(String type, double x, double y):super(type,x,y){
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.add(updateCollisionAABB);
  }
}