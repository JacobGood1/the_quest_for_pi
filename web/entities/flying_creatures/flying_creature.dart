part of entity;

//TODO fix drawing code stagexl fail drawing bs!

abstract class FlyingCreature extends Entity with ErraticFly, Movement{
  int hp;

  FlyingCreature(String asset, double x, double y):super(asset, x, y);
}