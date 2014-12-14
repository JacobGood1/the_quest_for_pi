part of server;



List<GameWorldContainer> worlds = [gameWorld];

List<Player> playersToRemove = [];
List<Entity> entitiesToRemove = [];
List<Entity> entitiesToAddToGameWorld = [];
List<GameWorldContainer> worldsToAdd = [];

collidesWith(List<Entity> ent, String type){
  for(var i = 0; i < ent.length; i++){
    if(ent[i].type == type){
      return true;
    }
  }
  return false;
}

class PhysicsState{
  GameLoopIsolate physicsLoop = new GameLoopIsolate();
  PhysicsState(){  //send only one message entity!
    if(gameWorld != null){
      physicsLoop.onUpdate = ((physicsLoop) {
        worlds.forEach((GameWorldContainer world) {
          //COMBAT WORLD
          if(world is CombatGameWorld){
            world.playerEntities.forEach((Player player) {
              player.updateAllCombatModeComponents(physicsLoop.dt);
            });
            world.entities.forEach((Entity entity) {
              entity.updateAllCombatModeComponents(physicsLoop.dt);
            });
          }
          //COMBAT WORLD END

          //GAMEWORLD
          else if(world is GameWorld){
            for(var i = 0; i < world.playerEntities.length; i++){
              Player player = world.playerEntities[i];
              player.updateAllComponents(physicsLoop.dt);
              if(collidesWith(player.collidingWith.toList(), 'Goblin')){  //TODO give players the ability to enter instances!
                if(!player.inInstance){
                  List goblinCollisions =
                  player
                    .collidingWith
                    .toList()
                    .where((Entity e) => e is Goblin).toList();

                  CombatGameWorld cw = new CombatGameWorld([player], goblinCollisions);
                  //add players and entities that need to be removed from the gameWorld
                  playersToRemove.add(player);
                  //position the goblins that collided with the player to be on the opposite side!
                  goblinCollisions.forEach((Entity goblin) {
                    entitiesToRemove.add(goblin);
                    cw.positionEntity(goblin);
                  });  //TODO remove bushes from interaction
                  worldsToAdd.add(cw);
                  //create an instance star so that others may enter the combat, or avoid it
                  CombatStar s = new CombatStar(player.position.x,player.position.y, cw);
                  cw.positionEntity(player);
                  entitiesToAddToGameWorld.add(s);
                  //webSocketSendToClient(pingClients, player.ID, MessageTypes.NEW_ENTITY, s.toJson()); //TODO what the heck is this? remove this crap
                }
              } else if(collidesWith(player.collidingWith.toList(), 'CombatStar')){
                player.collidingWith.toList().forEach((Entity e) {
                  if(e is CombatStar){
                    playersToRemove.add(player);
                    e.cw.playerEntities.add(player);
                    e.cw.positionEntity(player);
                  }
                });
              }
            }
            //remove all entities that entered the instance
            playersToRemove.forEach((Player player) => world.playerEntities.remove(player));  //TODO send a message to the client to remove these entities or to switch worlds vvv see other todo as well
            entitiesToRemove.forEach((Entity entity) => world.entities.remove(entity));

            entitiesToAddToGameWorld.forEach((Entity e) => world.entities.add(e));

            playersToRemove.clear();
            entitiesToRemove.clear();
            entitiesToAddToGameWorld.clear();


            world.entities.forEach((Entity entity) {
              if(entity is Goblin){
                if(collidesWith(entity.collidingWith.toList(), 'CombatStar')){
                  entity.collidingWith.toList().forEach((Entity e) {
                    if(e is CombatStar){
                      e.cw.entities.add(entity);
                      e.cw.positionEntity(entity);
                      entitiesToRemove.add(entity);
                    }
                  });
                } else{
                  entity.updateAllComponents(physicsLoop.dt);
                }
              } else{
                entity.updateAllComponents(physicsLoop.dt);
              }
            });
          }
          //GAMEWORLD END
          entitiesToRemove.forEach((Entity entity) => world.entities.remove(entity));
          entitiesToRemove.clear();
        });
        // add new worlds
        worldsToAdd.forEach((world) => worlds.add(world));
        worldsToAdd.clear();


        /*gameWorld.playerEntities.forEach((Player player) {  //TODO state problems could arise from this...have to see later check back

          if(player.inCombat){
            //create a combat world and add them to that world
            //remove them from the server persistent world, thus adding them to their own instance
            if(!player.inInstance){

              List<CombatStar> stars = [];
              var starCounter = 0, starConverter = {};

              CombatGameWorld combatWorld = new CombatGameWorld([player],player.collidingWith.toList()); //this is what is modding the list dummy!


              stars.add(new CombatStar(player.position.x, player.position.y));
              entitiesToAddToGameWorld.add(stars[starCounter++]);  //TODO add instance information and collision to combat star, remove all players and entities that get covered by star!
              player.collidingWith.toList().forEach((Entity ent) {
                stars.add(new CombatStar(ent.position.x, ent.position.y));
                entitiesToAddToGameWorld.add(stars[starCounter++]);
                entitiesToRemoveFromGameWorldAndAddToInstance.add(ent);
              });
              playersToRemoveFromGameWorldAndAddToInstance.add(player);

              webSocketSendToClients(pingClients,MessageTypes.NEW_INSTANCE, combatWorld.toJson());
            }

          } else{
            player.updateAllComponents(physicsLoop.dt);
          }
        });*/

        /*if(playersToRemoveFromGameWorldAndAddToInstance.isNotEmpty){
        playersToRemoveFromGameWorldAndAddToInstance.forEach((player) {
          gameWorld.playerEntities.remove(player);
        });
        webSocketSendToClients(
            pingClients,
            MessageTypes.PLAYERS_ENTERED_INSTANCE,
            new Map.fromIterable(
                playersToRemoveFromGameWorldAndAddToInstance,
                key: (Player player) => player.ID,
                value: (Player player) => player.toJson()
            )..addAll({'instance': combatWorld.toJson()})
        );
      }
      if(entitiesToRemoveFromGameWorldAndAddToInstance.isNotEmpty){
        entitiesToRemoveFromGameWorldAndAddToInstance.forEach((entity) {
          gameWorld.entities.remove(entity);
        });
        webSocketSendToClients(
            pingClients,
            MessageTypes.ENTITIES_ENTERED_INSTANCE,
            new Map.fromIterable(
                entitiesToRemoveFromGameWorldAndAddToInstance,
                key: (Entity entity) => entity.ID,
                value: (Entity entity) => entity.toJson()
            )..addAll({'instance': combatWorld.toJson()})
        );
      }
      if(entitiesToAddToGameWorld.isNotEmpty){
        entitiesToAddToGameWorld.forEach((entity) {
          gameWorld.entities.add(entity);
        });
        webSocketSendToClients(
            pingClients,
            MessageTypes.NEW_ENTITIES,
            new Map.fromIterable(
                entitiesToAddToGameWorld,
                key: (Entity entity) => entity.ID,
                value: (Entity entity) => entity.toJson()
            )
        );
      }*/
        //TODO syncstate as a single message to the clients, i send all the worlds the client figures out what effing world it needs to go to!
        webSocketSendToClients(pingClients, MessageTypes.SYNC_STATE, makeWorldsIntoJSON(physicsLoop.dt));  //TODO get client to handle the new syncstate, sends multiplae states!
      });
    }

  }
}
//TODO players on the client can just search for their ID in player entities and make that world their world!  rebuild world on leaving and entering!
Map makeWorldsIntoJSON(dt){
  return
    new Map.fromIterable(
        worlds,
        key: (GameWorldContainer world) {
          if(world is GameWorld){
            return 'MainWorld';
          } else{
            return 'CombatWorld';
          }
        },
        value: (GameWorldContainer world) => world.toJson()..addAll({'dt': dt}));
}

class ServerHandler{
  final RegExp keyCipher = new RegExp(r'[a-z]');
  Map clients = {};
  //incoming messages are handled here!
  //SERVER_HANDLE
  handle(WebSocket ws, StreamSubscription conn, Map message){
    if(MessageTypes.isNEW_CLIENT(message)){ //new client so make a new player and give the map that players ID
      Player np = new Player(200.0,200.0);
      gameWorld.addPlayer(np);
      clients[conn] = np.ID;   //get a pointer to the subscription so we can remove it when done
      for(GameWorldContainer world in worlds){
        if(world is GameWorld){
          webSocketSendToClients(pingClients,MessageTypes.NEW_CLIENT, {'NEW_PLAYER_ID': np.ID}..addAll(world.toJson()));
        }
      }
    } else if(MessageTypes.isCLIENT_INPUT(message)){
      String keysFromClient = MessageTypes.getData(message);
      for(Player player in gameWorld.playerEntities){
        if(MessageTypes.getID(message) == player.ID){
          List matches = keyCipher.allMatches(keysFromClient).toList(),
               currentKeys = new List.generate(matches.length,(i) => matches[i][0]);
          player.currentActiveKeys = currentKeys;
        }
      }
    }
  }
  //when connection closes go here!
  connectionDone(close, conn){
    //remove the client from the server and tell all other client to also remove the client
    var id = clients[conn];
    gameWorld.removePlayer(id);
    clients.remove(conn);
    webSocketSendToClients(pingClients, MessageTypes.CLOSE_CONNECTION,{MessageTypes.CLIENT_ID : id});
    close();
  }
}




