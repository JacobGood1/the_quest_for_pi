part of client_entity;

abstract class Terrain extends Entity with Collision_AABB{
  Terrain(String type, double x, double y, String ID):super(type,x,y, ID){
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.add(updateCollisionAABB);
  }
}