part of entity;

abstract class Terrain extends Entity with Collision_AABB{

  Terrain(String asset, double x, double y):super(asset, x, y);

}