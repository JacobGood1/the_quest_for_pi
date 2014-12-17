part of server_entity;

class GoblinSpear extends Entity with Collision_AABB, Movement{
  GoblinSpear(x,y):super(x,y){
    componentCombatModeFunctionList.add(_updateAnimateGoblinSpear);
  }

  _updateAnimateGoblinSpear(){
    moveUp(10.0);
  }
}

