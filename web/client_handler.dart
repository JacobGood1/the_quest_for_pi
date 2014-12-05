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
      }else{
        var newPlayerID = messageData['NEW_PLAYER_ID'];
        List serverPlayers = messageData['playerEntities'] as List;
        for(Map player in serverPlayers){
          if(player['ID'] == newPlayerID){
            GameWorld.addPlayerEntity(makeNewObjectFromJSON(player));
          }
        }
      }


    } else if(MessageTypes.isSYNC_STATE(message)){
      if(GameWorld.isGameWorldReady){
        List serverPlayers = messageData['playerEntities'] as List;
        List serverEntities = messageData['entityManager'] as List;
        double dt = messageData['dt'];

        for(var i = 0; i < serverPlayers.length; i++){
          var sp = serverPlayers[i], id = sp['ID'], isDead = sp['isDead'];

          for(Player player in GameWorld.playerEntities){
            if(player.ID == id){
              if(isDead){
                GameWorld.playerEntities.remove(player);  //TODO might not work alters a list while looping
                break;
              }
              player.extractData(sp);
              player.updateAllComponents(dt);

              break;
            }
          }
        }


        /*serverTime = parseTime(messageData['time']);
        clientTime = serverTime.difference(serverLastTime);

        //get the server entities
        List otherGameWorldPlayerEntities = (messageData['playerEntities'] as List).map((entity) => makeNewObjectFromJSON(entity)).toList();
        List otherGameWorldEntities = (messageData['entityManager'] as List).map((entity) => makeNewObjectFromJSON(entity)).toList();*/

        //clear the entities from the client
        /*GameWorld.clearEntities();
        //add the entities from the server
        otherGameWorldEntities.forEach((entity) => GameWorld.addPlayerEntity(entity));
        otherGameWorldPlayerEntities.forEach((entity) => GameWorld.addEntity(entity)); //TODO make this lerp instead of insta update
        serverLastTime = serverTime;*/
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
