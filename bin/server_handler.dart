part of server;



List<GameWorldContainer> worlds = [MAIN_WORLD];
List<GameWorldContainer> worldsToAdd = [];
List<GameWorldContainer> worldsToRemove = [];

SlowPrint slowPrint = new SlowPrint();

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
  PhysicsState() {
    if (MAIN_WORLD != null) {
      physicsLoop.onUpdate = ((physicsLoop) {
        while(MAIN_WORLD.countGobbyPop() != 3){
          MAIN_WORLD.generateNewEnemies(1);
        }
        MAIN_WORLD.playerEntities.forEach((Player player) {
          player.updateAllComponents(physicsLoop.dt);
          if (player.collidingWith.length >= 1) {
            var collisions = player.collidingWith.toList();
            if (collidesWith(collisions, 'Goblin')) {
              var goblinsThatPlayerCollidedWith = player.collidingWith.where((Entity e) => e is Goblin).toList();
              CombatGameWorld combatGameWorld = new CombatGameWorld([], []);
              CombatStar combatStar = new CombatStar(player.position.x, player.position.y, combatGameWorld);
              //set up CombatGameWorld
              combatGameWorld.addPlayer(player);
              goblinsThatPlayerCollidedWith.forEach((Goblin g) {
                combatGameWorld.addEntity(g);
              });

              //make adjustments to GameWorld
              MAIN_WORLD.addCombatStar(combatStar);

            } else if(collidesWith(collisions, 'CombatStar')){
              CombatStar cs = collisions.where((e) => e is CombatStar).first;
              cs.combatGameWorld.addPlayer(player);
              //remove then add all the players and goblins back, this hack sucks im just trying to get this done
              cs.combatGameWorld.playerEntities.forEach((Player p) {
                cs.combatGameWorld.playersToAdd.add(p);
              });
              cs.combatGameWorld.entities.forEach((Entity e) {
                cs.combatGameWorld.entitiesToAdd.add(e);
              });
            }
          }
        });
        MAIN_WORLD.entities.forEach((Entity entity) {
          entity.updateAllComponents(physicsLoop.dt);
          if (entity is Goblin) {
            Goblin goblin = entity;
            var goblinCollisions = goblin.collidingWith.toList();
            if (collidesWith(goblinCollisions, 'CombatStar')) {
              CombatStar combatStar;
              for (Entity e in goblinCollisions) {
                if (e is CombatStar) {
                  combatStar = e;
                }
              }
              //add and position goblins to star instance
              combatStar.combatGameWorld.addEntity(goblin);
            }
          }
          else if (entity is Bush) {
            Bush bush = entity;
          }
          else if (entity is CombatStar) {
              CombatStar combatStar = entity;
              var allPlayersDead = true, allGoblinsDead = true;

              combatStar.combatGameWorld.playerEntities.forEach((Player player) {
                if(player.isNotDead){
                  allPlayersDead = false;
                  player.updateAllCombatModeComponents(physicsLoop.dt);
                }
              });
              if(allPlayersDead){
                combatStar.combatGameWorld.entities.forEach((Entity ent) {
                  if(ent is Goblin){
                    MAIN_WORLD.addEntity(ent);
                    ent.position = combatStar.position.copy();
                  }
                });
              } else{
                combatStar.combatGameWorld.entities.forEach((Entity ent) {
                  if(ent is Goblin){
                    if(ent.isNotDead){
                      allGoblinsDead = false;
                    }
                  }
                  ent.updateAllCombatModeComponents(physicsLoop.dt);
                });
                if(allGoblinsDead){
                  combatStar.combatGameWorld.playerEntities.forEach((Player p){
                    MAIN_WORLD.addPlayer(p);
                    p.position = combatStar.position.copy();
                  });
                }
              }
              if(allGoblinsDead || allPlayersDead){
                MAIN_WORLD.removeEntity(combatStar);
              }
            }

        });

        MAIN_WORLD
          ..entitiesToAdd.forEach((e) => MAIN_WORLD.entities.add(e))
          ..playersToAdd.forEach((player) => MAIN_WORLD.playerEntities.add(player))
          ..entitiesToRemove.forEach((entity) => MAIN_WORLD.entities.remove(entity))
          ..playersToRemove.forEach((player) => MAIN_WORLD.playerEntities.remove(player));

        MAIN_WORLD.entities.forEach((Entity e) {
          if (e is CombatStar) {
            CombatStar combatStar = e;
            combatStar.combatGameWorld
              ..entitiesToAdd.forEach((ent) => combatStar.combatGameWorld.entities.add(ent))
              ..playersToAdd.forEach((player) => combatStar.combatGameWorld.playerEntities.add(player));
          }
        });

        webSocketSendToClients(pingClients, MessageTypes.SYNC_STATE, makeWorldsIntoJSON(physicsLoop.dt)); //TODO get client to handle the new syncstate, sends multiplae states!
        MAIN_WORLD.entities.forEach((Entity e) {
          if (e is CombatStar) {
            (e as CombatStar).combatGameWorld
              ..entitiesToAdd.clear()
              ..entitiesToRemove.clear()
              ..playersToRemove.clear()
              ..playersToAdd.clear();
          }
        });
        MAIN_WORLD
          ..entitiesToAdd.clear()
          ..entitiesToRemove.clear()
          ..playersToAdd.clear()
          ..playersToRemove.clear();
      });
    }
  }
}
//TODO players on the client can just search for their ID in player entities and make that world their world!  rebuild world on leaving and entering!

Map makeWorldsIntoJSON(dt){
  int combatWorldCounter = 0;
  return
    new Map.fromIterable(
        worlds,
        key: (GameWorldContainer world) {
          if(world is GameWorld){
            return 'MainWorld';
          } else{
            combatWorldCounter++;
            return 'CombatWorld${combatWorldCounter}';
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
      Player np = new Player(200.0,200.0, MAIN_WORLD);
      MAIN_WORLD.playerEntities.add(np);
      clients[conn] = np;   //get a pointer to the subscription so we can remove it when done
      for(GameWorldContainer world in worlds){
        if(world is GameWorld){
          webSocketSendToClients(pingClients,MessageTypes.NEW_CLIENT, {'NEW_PLAYER_ID': np.ID}..addAll(world.toJson()));
        }
      }
    }
    else if(MessageTypes.isCLIENT_ANSWER(message)){
      String answer = MessageTypes.getData(message),
             clientID = message['clientID'];
      for(Entity e in MAIN_WORLD.entities){
        if(e is CombatStar){
          CombatGameWorld world = e.combatGameWorld;
          world.playerEntities.forEach((Player player) {
            if(player.ID == clientID){
              player.problemSolutionAttempt = answer;
            }
          });
        }
      }
    } else if(MessageTypes.isCLIENT_INPUT(message)){
      String keysFromClient = MessageTypes.getData(message);
      for(Player player in MAIN_WORLD.playerEntities){
        if(MessageTypes.getID(message) == player.ID){
          List matches = keyCipher.allMatches(keysFromClient).toList(),
          currentKeys = new List.generate(matches.length,(i) => matches[i][0]);
          player.currentActiveKeys = currentKeys;
        }
      }
    } else if(MessageTypes.isCLIENT_TARGET(message)){
      for(Entity e in MAIN_WORLD.entities){
        if(e is CombatStar){
          CombatGameWorld combatWorld = e.combatGameWorld;
          var currentPlayer;
          for(Player player in combatWorld.playerEntities){
            if(player.ID == message['clientID']){
              currentPlayer = player;
              break;
            }
          }
          var temp = combatWorld.entities
                                .where((ent) => ent.ID == message['data']);
          //if temp is empty no entity was found with the id so the player must have targetted another player
          if(temp.isNotEmpty){
            currentPlayer.attackTarget = temp.first;
          } else{
            currentPlayer.attackTarget = combatWorld.playerEntities.where((player) => player.ID == message['data']).first;
          }
        }
      }
    }else if(MessageTypes.isCLIENT_FIREBALL(message)) {
      List worldAndPlayer = findPlayerInCombat(message);
      Player currentPlayer = worldAndPlayer[0]; CombatGameWorld combatWorld = worldAndPlayer[1];
      if(currentPlayer.attackTarget != null) {
        if(currentPlayer.spellReserve >= 1){
          currentPlayer.castFireBall();
          currentPlayer.spellReserve--;
        }

      }
    }

  }

  //returns both the current player and the instance they are in
  List findPlayerInCombat(message){
    var currentPlayer, combatWorld;
    for (Entity e in MAIN_WORLD.entities) {
      if (e is CombatStar) {
        combatWorld = e.combatGameWorld;
        for (Player player in combatWorld.playerEntities) {
          if (player.ID == message['clientID']) {
            currentPlayer = player;
            break;
          }
        }
      }
      if(currentPlayer != null){
        return [currentPlayer, combatWorld];
      }
    }
  }
  //when connection closes go here!
  connectionDone(close, conn){
    //remove the client from the server and tell all other client to also remove the client
    Player player = clients[conn];
    for(GameWorldContainer world in worlds){
      for(var i = 0; i < world.playerEntities.length; i++){
        if(player == world.playerEntities[i]){
          world.removePlayer(player);
        }
      }
    }
    clients.remove(conn);
    close();
  }
}




