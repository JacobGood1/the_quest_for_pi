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
        currentGameWorld = new GameWorld(messageData);
        ID = messageData['NEW_PLAYER_ID'];
        firstTime = false;
      }else{
        //if it is the main game world then do not add the player, we are in an instance
        if(currentGameWorld is GameWorld){
          var newPlayerID = messageData['NEW_PLAYER_ID'];
          List serverPlayers = messageData['playerEntities'] as List;
          for(Map player in serverPlayers){
            if(player['ID'] == newPlayerID){
              currentGameWorld.addPlayerEntity(makeNewObjectFromJSON(player));
            }
          }
        }
      }


    } else if(MessageTypes.isSYNC_STATE(message)){
      //client needs to find the world its id is in and sync itself accordingly
      GameWorldContainer prevGameWorld = currentGameWorld;
      var messageData;
      if(currentGameWorld != null){
        var gameWorldFromServer;
        if(currentGameWorld.isGameWorldReady){
          (message['data'] as Map).forEach((k,v) {
            (v['playerEntities'] as List<Map>).forEach((player) {
              if(player['ID'] == ID){
                gameWorldFromServer = k;
                messageData = v;
              }
            });
          });



          //TODO sometimes dt goes null find out why
          double dt = messageData['dt'];


          if(gameWorldFromServer == 'MainWorld'){
            if(!(prevGameWorld is GameWorld)){
              //must have left an instance rebuild the world
              currentGameWorld = new GameWorld(messageData);
            }
          } else if(gameWorldFromServer == 'CombatWorld'){
            //TODO add update logic specific for this world to see if we can locate the startup error!
            if(!(prevGameWorld is CombatGameWorld)){
              //must have left an instance rebuild the world
              currentGameWorld = new CombatGameWorld(messageData);  //TODO this bug might have to do with server not switching the combat werld right?
            }
          }




        currentGameWorld.updateEntities(messageData['entities'], messageData['playerEntities'], dt);



        }
      }

    }else if(MessageTypes.isNEW_ENTITY(message)){
      currentGameWorld.addEntity(makeNewObjectFromJSON(message['data']));
    } else if(MessageTypes.isENTITIES_ENTERED_INSTANCE(message)){

    }else if(MessageTypes.isCLOSE_CONNECTION(message)){
      currentGameWorld.removePlayer(MessageTypes.getID(MessageTypes.getData(message)));
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
