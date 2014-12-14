part of game_world_client;


class GameWorld extends GameWorldContainer{
  bool isFirstTime = false;
  var entitySize = 64.0;
  var entityOffset = 32.0; //size / 2.0;
  List assets = [];

  GameWorld(Map messageFromServerData){  //TODO see if this works when leaving an instance!
    initGameWorld(messageFromServerData, (){
      generateObjectsFromServerEntities(messageFromServerData);
    });
  }

  void updateEntities(List<Map>serverEntities, List<Map>serverPlayers, num dt){
    for(var i = 0; i < serverEntities.length; i++){
      var se = serverEntities[i];
      for(Entity entity in entities){
        if(entity.ID == se['ID']){
          entity.extractData(se); //this will mutate the clients to reflect the server objects
          if(entity.isDead){
            entities.remove(entity);  //TODO might not work alters a list while looping make an add to dead list cleanup
            break;
          }
          entity.updateAllComponents(dt);
          break;
        }
      }
    }
    for(var i = 0; i < serverPlayers.length; i++){
      var pe = serverPlayers[i];
      for(Entity player in playerEntities){
        if(player.ID == pe['ID']){
          player.extractData(pe); //this will mutate the clients to reflect the server objects
          if(player.isDead){
            playerEntities.remove(player);  //TODO might not work alters a list while looping make an add to dead list cleanup
            break;
          }
          player.updateAllComponents(dt);
          break;
        }
      }
    }
  }

  void removePlayer(String id){
    for(var i = 0; i < playerEntities.length; i++){
      Player player = playerEntities[i];
      if(player.ID == id){
        playerEntities.remove(player);
        stage.removeChild(player);
        break;
      }
    }
  }
  void clearEntities(){
    if(stage.numChildren != 0){
      stage.removeChildren(0,stage.numChildren - 1);
    }
    entities.clear();
    playerEntities.clear();
  }

  void addEntities(List<Entity> e){
    e.forEach((Entity e){
      entities.add(e);
      stage.addChild(e);
    });
  }

  void addEntity(Entity e){
    entities.add(e);
    stage.addChild(e);
  }
  void addPlayerEntity(Entity e){
    playerEntities.add(e);
    stage.addChild(e);
  }
  Map toJson() {
    return {'playerEntities' : playerEntities.map((e) => e.toJson).toList(),
        'entityManager'  : entities.map((e) => e.toJson).toList()};
  }
}
makeNewObjectFromJSON(Map entity){
  String type = entity['type'],
  id = entity['ID'];
  double posX = entity['positionX'],
  posY = entity['positionY'];
  if(type == 'Bush'){
    return new Bush(id, posX,posY);
  }else if(type == 'Bat'){
    return new Bat(id, posX, posY);
  }else if(type == 'Player'){
    return new Player(
        id,
        posX,
        posY,
        entity['currentAnimationFrame'],
        entity['currentAnimationState'],
        entity['currentSoundState']);
  }else if(type == 'Goblin'){
    return new Goblin(
        id,
        posX,
        posY,
        entity['currentAnimationFrame'],
        entity['currentAnimationState'],
        entity['currentSoundState']);
  }else if(type == 'CombatStar'){
    return new CombatStar(
        id,
        posX,
        posY);
  }
}