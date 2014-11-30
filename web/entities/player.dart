part of client_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB{
  Player(x, y):super('Player',x,y);
}