part of server;



//TODO remove clientID on disconnect and remove it from the entities


class ServerHandler{
  //incoming messages are handled here!
  handle(WebSocket ws, StreamSubscription conn, Map message){  //TODO CLEAN THIS CRAP UP
    if(MessageTypes.isNEW_PLAYER(message)){  //if the client is new
      var clientID = uuid.v4(),
      player = new Player(clientID, 0.0, 0.0);//generate an id for the client
      websocketSend(ws, MessageTypes.NEW_PLAYER, clientID);
      clientIDs.add(clientID);
      playerEntities.add(player);
      clients[clientID] = player;
      clientWebsocketPointers[conn] = clientID;
    }
    //TODO you have client inputs coming in now update the players and sync the state!
    else if(MessageTypes.isCLIENT_INPUT(message)){
      clientInput[MessageTypes.getID(message)] = MessageTypes.getData(message);

    }//
    else{ //must be a server update message

      //print(message[MessageTypes.CLIENT_ID]);
      //print('reciving null input');
    }
  }

  //when connection closes go here!
  connectionDone(close, conn){
    String clientID = clientWebsocketPointers[conn];  //remove all references to players!

    clientWebsocketPointers.remove(conn);
    clientInput.remove(clientID);
    clientIDs.remove(clientID);
    for(Player player in playerEntities){
      if(player.ID == clientID){
        playerEntities.remove(player);
        break;
      }
    }
    clients.remove(clientID);
    close();
  }
}




