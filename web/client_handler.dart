part of client;

//var port = uri.port != 8080 ? 80 : 9090; //production
var port = uri.port != 63342 ? 80 : 9090; //JACOB
//var port = uri.port != 55125 ? 80 : 9090; //TRAVIS


class ClientHandler{
  bool firstTime = true;

  onOpen(WebSocket ws){
    print("Connected");
    webSocket = ws;
    webSocketSendToServer(webSocket,MessageTypes.NEW_CLIENT, '', ID);
  }

  onClose(WebSocket ws){
    print("Disconnected");
  }

  onError(WebSocket ws){
    print("Error");
  }
  //CLIENT_HANDLE
  incomingMessage(Map message) {
    Map messageData = message['data'];
    String messageType = message['type'];
    if(MessageTypes.isNEW_CLIENT(message)){
      if(firstTime){
        new GameWorld(messageData);
        ID = messageData['NEW_PLAYER_ID'];
        firstTime = false;
      }
    } else if(MessageTypes.isSYNC_STATE(message)){
      //TODO make this lerp instead of insta update
      if(GameWorld.isGameWorldReady){
        //get the server entities
        List otherGameWorldEntities = (messageData['entityManager'] as List).map((entity) => makeNewObjectFromJSON(entity)).toList();
        //clear the entities from the client
        GameWorld.clearEntities();
        //add the entities from the server
        otherGameWorldEntities.forEach((entity) => GameWorld.addEntity(entity));
      }
    }
  }
  outgoingMessage(String messageType, String data){  //id should be automatic

    webSocketSendToServer(webSocket, messageType, data, ID);
  }
}
