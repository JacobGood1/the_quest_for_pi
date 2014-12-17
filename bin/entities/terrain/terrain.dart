part of server_entity;

abstract class Terrain extends Entity with Collision_AABB{
  Terrain(double x, double y, GameWorldContainer gw):super(x,y){
    inWhatInstance = gw;
    componentInitFunctionList.add(initCollisionAABB);
    initAllComponents();
    componentUpdateFunctionList.add(updateCollisionAABB);
  }
}