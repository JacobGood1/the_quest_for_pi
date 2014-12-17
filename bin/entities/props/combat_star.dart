part of server_entity;

class CombatStar extends Entity with Collision_AABB{
  CombatGameWorld combatGameWorld;
  CombatStar(x,y, this.combatGameWorld):super(x,y){
    componentInitFunctionList.addAll([initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateCollisionAABB]);
    type = 'CombatStar';
  }

  Map toJson(){
    return
      {
          'ID': this.ID,
          'positionX': this.position.x,
          'positionY': this.position.y,
          'type': this.type,
          'combatGameWorld' : this.combatGameWorld
      };
  }
}