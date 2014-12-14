part of game_world_client;



bool firstTimeCombatWorld = true;

class CombatGameWorld extends GameWorldContainer{
  static Bitmap backGround;
  CombatGameWorld(Map messageData){
    CombatGameWorld.backGround = new Bitmap(resourceManager.getBitmapData('backGroundCombat'))
      ..scaleX = 2
      ..scaleY = 2;
    canvas.width = backGround.width.toInt();
    canvas.height = backGround.height.toInt();
    stage.addChild(backGround);
    generateObjectsFromServerEntities(messageData);
    isGameWorldReady = true;
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
          entity.updateAllCombatModeComponents(dt);
          break;
        }
      }
    }

    for(var i = 0; i < serverPlayers.length; i++){
      var pe = serverPlayers[i];
      for(Player player in playerEntities){
        if(player.ID == pe['ID']){
          player.extractData(pe); //this will mutate the clients to reflect the server objects
          if(player.isDead){
            playerEntities.remove(player);  //TODO might not work alters a list while looping make an add to dead list cleanup
            break;
          }
          player.updateAllCombatModeComponents(dt);
          break;
        }
      }
    }

  }

  void positionEntities(num time){
    //Vector positionOffSet = new Vector()
    playerEntities.forEach((Player player) {

      player.updateAllCombatModeComponents(time);
    });
    entities.forEach((entity) => entity.updateAllCombatModeComponents(time));
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
    return {
        'playerEntities' : playerEntities.map((e) => e.toJson).toList(),
        'entities'  : entities.map((e) => e.toJson).toList()};
  }
}