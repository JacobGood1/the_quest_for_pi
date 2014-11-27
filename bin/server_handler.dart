part of server;



class PhysicsState{
  GameLoopIsolate physicsLoop = new GameLoopIsolate();
  PhysicsState(){
    physicsLoop.onUpdate = ((physicsLoop) {
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
  //incoming messages are handled here!
  //SERVER_HANDLE
  handle(WebSocket ws, StreamSubscription conn, Map message){
    if(MessageTypes.isNEW_CLIENT(message)){
      webSocketSendToClient(pingClients ,MessageTypes.NEW_CLIENT, GameWorld.toJson());
    }
  }
  //when connection closes go here!
  connectionDone(close, conn){
    close();
  }
}




