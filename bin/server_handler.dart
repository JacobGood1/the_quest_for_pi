part of server;

class PhysicsState{
  GameLoopIsolate physicsLoop = new GameLoopIsolate();
  PhysicsState(){  //send only one message entity!
    physicsLoop.onUpdate = ((physicsLoop) {
      GameWorld.playerEntities.forEach((Player player) {
        if(player.inCombat){
          player.updateAllCombatModeComponents(physicsLoop.dt);
        } else{
          player.updateAllComponents(physicsLoop.dt);
        }
      });
      GameWorld.entities.forEach((Entity entity) {
        if(entity.inCombat){
          entity.updateAllCombatModeComponents(physicsLoop.dt);
        } else{
          entity.updateAllComponents(physicsLoop.dt);
        }
      });
      print(GameWorld.entities);
      webSocketSendToClient(pingClients, MessageTypes.SYNC_STATE, GameWorld.toJson()..addAll({'dt': physicsLoop.dt}));
    });
  }
}

class ServerHandler{
  final RegExp keyCipher = new RegExp(r'[a-z]');
  Map clients = {};
  //incoming messages are handled here!
  //SERVER_HANDLE
  handle(WebSocket ws, StreamSubscription conn, Map message){
    if(MessageTypes.isNEW_CLIENT(message)){ //new client so make a new player and give the map that players ID
      Player np = new Player(200.0,200.0);
      GameWorld.addPlayer(np);
      clients[conn] = np.ID;   //get a pointer to the subscription so we can remove it when done
      webSocketSendToClient(pingClients,MessageTypes.NEW_CLIENT, {'NEW_PLAYER_ID': np.ID}..addAll(GameWorld.toJson()));
    } else if(MessageTypes.isCLIENT_INPUT(message)){
      String keysFromClient = MessageTypes.getData(message);
      for(Player player in GameWorld.playerEntities){
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
    GameWorld.removePlayer(id);
    clients.remove(conn);
    webSocketSendToClient(pingClients, MessageTypes.CLOSE_CONNECTION,{MessageTypes.CLIENT_ID : id});
    close();
  }
}




