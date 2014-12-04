part of client;

//var port = uri.port != 8080 ? 80 : 9090; //production
var port = uri.port != 63342 ? 80 : 9090; //JACOB
//var port = uri.port != 55125 ? 80 : 9090; //TRAVIS


class ClientHandler{
  bool firstTime = true;
  DateTime serverTime, serverLastTime = new DateTime(0,0,0,0,0,0,0);
  Duration clientTime;

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
      if(GameWorld.isGameWorldReady){
        serverTime = parseTime(messageData['time']);
        clientTime = serverTime.difference(serverLastTime);

        //get the server entities
        List otherGameWorldPlayerEntities = (messageData['playerEntities'] as List).map((entity) => makeNewObjectFromJSON(entity)).toList();
        List otherGameWorldEntities = (messageData['entityManager'] as List).map((entity) => makeNewObjectFromJSON(entity)).toList();

        //clear the entities from the client
        GameWorld.clearEntities();
        //add the entities from the server
        otherGameWorldEntities.forEach((entity) => GameWorld.addPlayerEntity(entity));
        otherGameWorldPlayerEntities.forEach((entity) => GameWorld.addEntity(entity)); //TODO make this lerp instead of insta update
        serverLastTime = serverTime;
      }
    } else if(MessageTypes.isCLOSE_CONNECTION(message)){
      GameWorld.removePlayer(MessageTypes.getID(MessageTypes.getData(message)));
    }
  }
  outgoingMessage(String messageType, String data){  //id should be automatic
    webSocketSendToServer(webSocket, messageType, data, ID);
  }

  DateTime parseTime(Map time){
    time.forEach((k,v) => time[k] = int.parse(v));
    return new DateTime(time['year'], time['month'], time['day'], time['hour'], time['minute'], time['second'], time['millisecond']);
  }
}
