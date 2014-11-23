part of entity;

//TODO fix drawing code stagexl fail drawing bs!

abstract class FlyingCreature extends Entity with ErraticFly, Movement, Collision_AABB{
  int hp;

  FlyingCreature(String asset, double x, double y):super(asset, x, y);
}