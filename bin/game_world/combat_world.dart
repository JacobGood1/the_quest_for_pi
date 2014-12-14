part of server_game_world;


class CombatGameWorld extends GameWorldContainer{
  final Vector _playerPositionConstantCombatGameWorld = new Vector(800.0, 775.0);
  final Vector _entityPositionConstantCombatGameWorld = new Vector(400.0, 775.0);
  Vector _offsetCombatGoblinGameWorld = new Vector(0.0, 0.0);
  Vector _offsetCombatPlayerGameWorld = new Vector(0.0, 0.0);
  int _alternatePlayerCombatGameWorld = 1,
      _alternateGoblinCombatGameWorld = 1;


  CombatGameWorld(List playerEntities, List entities) : super(playerEntities, entities){  //TODO should only be on entity that enters but check to see
    entities.forEach((Entity ent) => ent.inInstance = true);
    playerEntities.forEach((Player player) {
      player.inInstance = true;
    });
  }


  void positionEntity(Entity ent){
    if(ent is Player){
      if(playerEntities.length == 1){
        ent.position = _playerPositionConstantCombatGameWorld.copy();
        ent.currentAnimationState = 'idle_combat';
        ent.currentAnimationFrame = 0;
      } else{
        if(playerEntities.length.isEven){
          _offsetCombatPlayerGameWorld += new Vector(0.0,50.0);
        }
        ent.position = _playerPositionConstantCombatGameWorld.copy() + _offsetCombatPlayerGameWorld * _alternatePlayerCombatGameWorld;
        _alternatePlayerCombatGameWorld *= -1;
        ent.currentAnimationState = 'idle_combat';
        ent.currentAnimationFrame = 0;
      }
    }
    if(ent is Goblin){
      if(entities.length == 1){
        ent.position = _entityPositionConstantCombatGameWorld.copy();
        ent.currentAnimationState = 'idle_combat';
        ent.currentAnimationFrame = 0;
      } else{
        if(entities.length.isEven){
          _offsetCombatGoblinGameWorld += new Vector(0.0,50.0);
        }
        ent.position = _entityPositionConstantCombatGameWorld.copy() + _offsetCombatGoblinGameWorld * _alternateGoblinCombatGameWorld;
        _alternateGoblinCombatGameWorld *= -1;
        ent.currentAnimationState = 'idle_combat';
        ent.currentAnimationFrame = 0;
      }
    }
  }
  Map toJson(){
    if(playerEntities.isNotEmpty && entities.isEmpty){
      return{
          'playerEntities' :  playerEntities.map((Entity e) => e.toJson()).toList(),
          'entities'       :  []
      };
    } else if(playerEntities.isEmpty && entities.isNotEmpty){
      return{
          'playerEntities' :  [],
          'entities'       :  entities.map((e) => e.toJson()).toList()
      };
    }else{
      return{
          'playerEntities' :  playerEntities.map((Entity e) => e.toJson()).toList(),
          'entities'       :  entities.map((e) => e.toJson()).toList()
      };
    }
  }
}