import 'dart:convert';


int spriteWidth = 50, spriteHeight = 50;
int canvasWidth = 1000, canvasHeight = 1000;

class MessageTypes{
  static String CLIENT_ID = 'clientID';
  static String NEW_PLAYER = 'newPlayer';
  static String CLOSE_CONNECTION = 'closeConnection';
  static String INPUT = 'input';
  static String NEW_ENTITY = 'newEntity';
  static String CLIENT_INPUT = 'clientInput';
  static String SYNC_STATE = 'syncState';

  static getData(Map message){
    return message['data'];
  }

  static getID(Map message){
    return message['clientID'];
  }

  static bool isCLIENT_ID(Map message){
    if(message['type'] == 'clientID'){
      return true;
    }
    return false;
  }

  static isNEW_PLAYER(Map message){
    if(message['type'] == 'newPlayer'){
      return true;
    }
    return false;
  }

  static isCLOSE_CONNECTION(Map message){
    if(message['type'] == 'closeConnection'){
      return true;
    }
    return false;
  }
  static isINPUT(Map message){
    if(message['type'] == 'input'){
      return true;
    }
    return false;
  }

  static isNEW_ENTITY(Map message){
    if(message['type'] == 'entity'){
      return true;
    }
    return false;
  }

  static isCLIENT_INPUT(Map message){
    if(message['type'] == 'clientInput'){
      return true;
    }
    return false;
  }

  static bool isSYNC_STATE(Map message){
    if(message['type'] == 'syncState'){
      return true;
    }
    return false;
  }


}

Map _genMessage(String type, Object data, [String clientID]){
  if(clientID == null){
    return {'type':type, 'data':data};
  }
  return {'type':type, 'clientID':clientID, 'data':data};
}

void websocketSend(webSocket, String type, Object data, [String clientID]){ //include the id if coming from the client
  if(clientID == null){ //must be a message from the server
    webSocket.add(JSON.encode(_genMessage(type,data)));
  }
  else{ //message is from the client
    webSocket.send(JSON.encode(_genMessage(type, data, clientID)));
  }
}
