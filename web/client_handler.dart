part of client;

//var port = uri.port != 8080 ? 80 : 9090; //production
var port = uri.port != 63342 ? 80 : 9090; //JACOB
//var port = uri.port != 55125 ? 80 : 9090; //TRAVIS

SlowPrint sp = new SlowPrint();
bool gameOver = false;

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
    if(!gameOver){

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
          String gameWorldFromServer;
          if(currentGameWorld.isGameWorldReady){
            (message['data'] as Map).forEach((k,v) {
              (v['playerEntities'] as List<Map>).forEach((player) {

                if(player['ID'] == ID){
                  gameWorldFromServer = k;
                  messageData = v;
                }
              });
              //player was not found in main world search combat stars
              if(gameWorldFromServer == null) {
                (v['entities'] as List<Map>).forEach((entity) {
                  if (entity['type'] == 'CombatStar') {
                    (entity['combatGameWorld']['playerEntities'] as List<Map>).forEach((player) {
                      if (player['ID'] == ID) {
                        gameWorldFromServer = entity['combatGameWorld']['type'];
                        messageData = new Map()..addAll(entity['combatGameWorld']);
                      }
                    });
                  }

                });
              }
            });
            if(gameWorldFromServer != null){
              List
              entitiesToAddFromServer = messageData['entitiesToAdd'],
              playersToAddFromServer = messageData['playersToAdd'],
              entitiesToRemoveFromServer = messageData['entitiesToRemove'],
              playersToRemoveFromServer = messageData['playersToRemove'];


              double dt = messageData['dt'];


              if(gameWorldFromServer == 'MainWorld'){
                if(!(prevGameWorld is GameWorld)){
                  //must have left an instance rebuild the world
                  currentGameWorld = new GameWorld(messageData);
                }
              } else if(gameWorldFromServer.contains('CombatWorld')){

                if(!(prevGameWorld is CombatGameWorld)){
                  //must have left an instance rebuild the world
                  currentGameWorld = new CombatGameWorld(messageData);
                }
              }

              //remove/add any entities/players that the server added/removed
              entitiesToAddFromServer.forEach((Map ent)  {currentGameWorld.addEntity(makeNewObjectFromJSON(ent));});
              playersToAddFromServer.forEach((Map player) => currentGameWorld.addPlayerEntity(makeNewObjectFromJSON(player)));
              entitiesToRemoveFromServer.forEach((Map ent) {
                for(var i = 0; i < currentGameWorld.entities.length; i++){
                  var entity = currentGameWorld.entities[i];
                  if(entity.ID == ent['ID']){
                    currentGameWorld.removeEntity(entity);
                    break;
                  }
                }
              });
              playersToRemoveFromServer.forEach((Map ent){
                for(var i = 0; i < currentGameWorld.playerEntities.length; i++){
                  var player = currentGameWorld.playerEntities[i];
                  if(player.ID == ent['ID']){
                    currentGameWorld.removePlayer(player.ID);
                    break;
                  }
                }
              });



              currentGameWorld
                ..updateEntities(messageData['entities'], messageData['playerEntities'], dt)
                ..drawHealthBars();
            } else{
              if(!gameOver){
                currentGameWorld.stage.removeChildren(0, currentGameWorld.stage.numChildren - 1);
                currentGameWorld.stage.addChild(
                    new TextField()
                      ..defaultTextFormat = new TextFormat('Spicy Rice', 30, Color.Black)
                      ..text = 'Game Over... Press Refresh'
                      ..x = 500
                      ..y = 500
                      ..width = 1000
                      ..height = 50
                      ..wordWrap = true
                );
              }
              gameOver = true;

            }
          }
        }

      }else if(MessageTypes.isNEW_ENTITY(message)){
        currentGameWorld.addEntity(makeNewObjectFromJSON(message['data']));
      } else if(MessageTypes.isENTITIES_ENTERED_INSTANCE(message)){

      }else if(MessageTypes.isCLOSE_CONNECTION(message)){
        currentGameWorld.removePlayer(MessageTypes.getID(MessageTypes.getData(message)));
      }
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
