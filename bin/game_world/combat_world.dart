part of server_game_world;


class CombatGameWorld extends GameWorldContainer{
  CombatStar exitPortal;
  final Vector _playerPositionConstantCombatGameWorld = new Vector(800.0, 775.0);
  final Vector _entityPositionConstantCombatGameWorld = new Vector(400.0, 775.0);
  Vector _offsetCombatGoblinGameWorld = new Vector(0.0, 0.0);
  Vector _offsetCombatPlayerGameWorld = new Vector(0.0, 0.0);
  int _alternatePlayerCombatGameWorld = 1,
      _alternateGoblinCombatGameWorld = 1;


  CombatGameWorld(List playerEntities, List entities) : super(playerEntities, entities){
    playerEntities.clear();
    entities.clear();
    type = 'CombatWorld';
  }


  void _positionEntity(Entity ent){
    if(ent is Player){
      if(_playerCounterCombatWorld == 1){
        ent.position = _playerPositionConstantCombatGameWorld.copy();
        ent.currentAnimationState = 'idle_combat';
        ent.currentAnimationFrame = 0;
      } else{
        if(_playerCounterCombatWorld.isEven){
          _offsetCombatPlayerGameWorld += new Vector(0.0,50.0);
        }
        ent.position = _playerPositionConstantCombatGameWorld.copy() + _offsetCombatPlayerGameWorld * _alternatePlayerCombatGameWorld;
        _alternatePlayerCombatGameWorld *= -1;
        ent.currentAnimationState = 'idle_combat';
        ent.currentAnimationFrame = 0;
      }
    }
    if(ent is Goblin){
      if(_goblinCounterCombatWorld == 1){
        ent.position = _entityPositionConstantCombatGameWorld.copy();
        if(!ent.isGoblinAttackingGoblinCombatAI){
          ent.currentAnimationState = 'idle_combat';
          ent.currentAnimationFrame = 0;
        }
      } else{
        if(_goblinCounterCombatWorld.isEven){
          _offsetCombatGoblinGameWorld += new Vector(0.0,50.0);
        }
        ent.position = _entityPositionConstantCombatGameWorld.copy() + _offsetCombatGoblinGameWorld * _alternateGoblinCombatGameWorld;
        _alternateGoblinCombatGameWorld *= -1;
        if(!ent.isGoblinAttackingGoblinCombatAI){
          ent.currentAnimationState = 'idle_combat';
          ent.currentAnimationFrame = 0;
        }
      }
    }
  }
  var _goblinCounterCombatWorld = 0;
  void addEntity(Entity e){
    if(e is Goblin){
      _goblinCounterCombatWorld++;
    }
    if(e is FireBall){
      entitiesToAdd.add(e);
      e.inWhatInstance = this;
    } else{
      _positionEntity(e);
      entitiesToAdd.add(e);
      e.inWhatInstance.entitiesToRemove.add(e);
      e.inWhatInstance = this;
      stageAddChild(e);
    }
  }
  var _playerCounterCombatWorld = 0;
  void addPlayer(Entity e){
    _playerCounterCombatWorld++;
    _positionEntity(e);
    playersToAdd.add(e);
    e.inWhatInstance.playersToRemove.add(e);
    e.inWhatInstance = this;
    stageAddChild(e);
  }
  void removeEntity(Entity e){
    entitiesToRemove.add(e);

  }
  void removePlayer(Entity e){
    playersToRemove.add(e);

  }
  void stageAddChild(e){}


  Map toJson(){
    Map toReturn = {
          'type'             : type,
          'playerEntities'   :  _handleEmptyEnts(playerEntities),
          'entities'         :  _handleEmptyEnts(entities),
          'entitiesToAdd'    : _handleEmptyEnts(entitiesToAdd),
          'playersToAdd'     : _handleEmptyEnts(playersToAdd),
          'entitiesToRemove' : _handleEmptyEnts(entitiesToRemove),
          'playersToRemove'  : _handleEmptyEnts(playersToRemove)
    };
    return toReturn;
  }

  _handleEmptyEnts(List<Entity> ents){
    if(ents.isNotEmpty){
      return ents.map((e) => e.toJson()).toList();
    }
    return [];
  }



}