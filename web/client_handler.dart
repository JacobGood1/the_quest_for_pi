part of client;

class ClientHandler{
  bool firstTime = true;

  onOpen(WebSocket ws){
    print("Connected");
    webSocket = ws;
    websocketSend(webSocket, MessageTypes.NEW_PLAYER, '', ID);

  }

  onClose(WebSocket ws){
    print("Disconnected");
  }

  onError(WebSocket ws){
    print("Error");
  }

  handleClient(Map message){
    if(MessageTypes.isNEW_PLAYER(message)){
      if(firstTime){
        ID = MessageTypes.getData(message);
        firstTime = false;
      }
      else{
        entities.add(new Player(message[MessageTypes.CLIENT_ID],0.0 ,0.0));
        print('another client connected');
      }
    }
    else if(MessageTypes.isSYNC_STATE(message)){

    }
  }


}


Map websocketRead(MessageEvent msg){
  return JSON.decode(msg.data);
}