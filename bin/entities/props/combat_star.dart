part of server_entity;

class CombatStar extends Entity with Collision_AABB{
  CombatGameWorld cw;
  CombatStar(x,y, this.cw):super(x,y){
    componentInitFunctionList.addAll([initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateCollisionAABB]);
    type = 'CombatStar';
  }
}