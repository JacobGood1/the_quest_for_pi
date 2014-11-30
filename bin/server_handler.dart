part of server;

class PhysicsState{
  GameLoopIsolate physicsLoop = new GameLoopIsolate();
  PhysicsState(){
    physicsLoop.onUpdate = ((physicsLoop) {
      GameWorld.playerEntities.forEach((Player player) => player.updateAllComponents(physicsLoop.dt));
      GameWorld.entityManager.forEach((Entity entity) => entity.updateAllComponents(physicsLoop.dt));
    });
  }
}
class ServerState{
  double SERVERTICK = 0.045,
  reset = 0.0;
  GameLoopIsolate serverLoop = new GameLoopIsolate();
  ServerState(){
    serverLoop.onUpdate = ((serverLoop) {
      reset += serverLoop.dt;
      if(reset >= SERVERTICK){
        reset = 0.0;
        webSocketSendToClient(pingClients, MessageTypes.SYNC_STATE, GameWorld.toJson());
      }
    });
  }
}

class ServerHandler{
  final RegExp keyCipher = new RegExp(r'[a-z]');
  //incoming messages are handled here!
  //SERVER_HANDLE
  handle(WebSocket ws, StreamSubscription conn, Map message){
    if(MessageTypes.isNEW_CLIENT(message)){ //new client so make a new player and give the map that players ID
      Player np = new Player(50.0,50.0);
      GameWorld.addEntity(np);
      GameWorld.addPlayer(np);
      webSocketSendToClient(pingClients,MessageTypes.NEW_CLIENT, {'NEW_PLAYER_ID': np.ID}..addAll(GameWorld.toJson()));
    } else if(MessageTypes.isCLIENT_INPUT(message)){
      String keysFromClient = MessageTypes.getData(message);
      for(Player player in GameWorld.playerEntities){
        if(MessageTypes.getID(message) == player.ID){
          List matches = keyCipher.allMatches(keysFromClient).toList(),
               currentKeys = new List.generate(matches.length,(i) => matches[i][0]);
          player.keysBeingPressed = currentKeys;
        }
      }
    }
  }
  //when connection closes go here!
  connectionDone(close, conn){
    close();
  }
}




