part of client;

class ClientHandler{
  bool firstTime = true;

  onOpen(WebSocket ws){
    print("Connected");
    webSocket = ws;
    websocketSend('clientID', '');

  }

  onClose(WebSocket ws){
    print("Disconnected");
  }

  onError(WebSocket ws){
    print("Error");
  }

  handle(Map message){
    if(MessageTypes.isID(message)){
      if(firstTime){
        ID = MessageTypes.getData(message);
        firstTime = false;
      }
    }
    else{
      onMessageRecieved(message);
    }
  }

  onMessageRecieved(Map message){
    //all messages from the server are handled here!
    print(ID);

  }
}

void websocketSend(String type, Object data){
  webSocket.send(JSON.encode({'type': type, 'data': data}));

}

Map websocketRead(MessageEvent msg){
  return JSON.decode(msg.data);
}