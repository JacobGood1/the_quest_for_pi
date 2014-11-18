part of server;

class ServerHandler{
  bool firstTime = true;

  handle(Map message){
    if(message['clientID'] == ''){ //if the client has no id, it must be a new client.
                                   //generate an id for the client
      var genClient = IDSetup();
      websocketSend(genClient);
    } else {
      onMessageRecieved(message);
    }
  }

  onMessageRecieved(Map message){
    //all messages from the client are handled here!

    if(MessageTypes.isNEW_PLAYER(message)){
      var data = MessageTypes.getData(message);

    }

  }
}


Map IDSetup(){
  String id = uuid.v4();
  return {'type': 'clientID', 'data': id};//{'clientID': id};
}




