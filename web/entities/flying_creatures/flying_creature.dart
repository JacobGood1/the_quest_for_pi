part of entity;

abstract class FlyingCreature extends Entity with ErraticFly, Movement{
  int hp;

  FlyingCreature(String asset, double x, double y):super(asset, x, y);
}