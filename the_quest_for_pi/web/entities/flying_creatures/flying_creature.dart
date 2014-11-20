part of entity;

abstract class FlyingCreature extends Entity with ErraticFly, Movement, Collision_AABB, ColliderAABBDebug{
  int hp;

  FlyingCreature(String asset, double x, double y):super(asset, x, y) {

  }
}