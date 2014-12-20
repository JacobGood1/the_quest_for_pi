import 'dart:convert';
import 'dart:math';

int spriteWidth = 50, spriteHeight = 50;
int canvasWidth = 1000, canvasHeight = 1000;


class SlowPrint{
  double speed = 0.0;
  slowPrint(message,dt){
    speed += dt;
    if(speed >= 1){
      print(message);
      speed = 0.0;
    }
  }
}

class MessageTypes{
  static String CLIENT_FIREBALL = 'clientFireBall';
  static String CLIENT_TARGET = 'clientTarget';
  static String CLIENT_ATTACK = 'clientAttack';
  static String CLIENT_ANSWER = 'clientAnswer';
  static String NEW_INSTANCE = 'newInstance';
  static String COMBAT_SYNC_STATE = 'combatSyncState';
  static String PLAYERS_ENTERED_INSTANCE = 'players_entered_instance';
  static String ENTITIES_ENTERED_INSTANCE = 'entities_entered_instance';
  static String NEW_CLIENT = 'newClient';
  static String CLIENT_ID = 'clientID';
  static String NEW_PLAYER = 'newPlayer';
  static String CLOSE_CONNECTION = 'closeConnection';
  static String INPUT = 'input';
  static String NEW_ENTITY = 'newEntity';
  static String NEW_ENTITIES = 'newEntities';
  static String CLIENT_INPUT = 'clientInput';
  static String SYNC_STATE = 'syncState';

  static getData(Map message){
    return message['data'];
  }

  static getID(Map message){
    return message['clientID'];
  }

  static bool isCLIENT_FIREBALL(Map message){
    if(message['type'] == 'clientFireBall'){
      return true;
    }
    return false;
  }

  static bool isCLIENT_TARGET(Map message){
    if(message['type'] == 'clientTarget'){
      return true;
    }
    return false;
  }
  static bool isCLIENT_ATTACK(Map message){
    if(message['type'] == 'clientAttack'){
      return true;
    }
    return false;
  }
  static bool isNEW_INSTANCE(Map message){
    if(message['type'] == 'newInstance'){
      return true;
    }
    return false;
  }
  static bool isCLIENT_ANSWER(Map message){
    if(message['type'] == 'clientAnswer'){
      return true;
    }
    return false;
  }

  static bool isNEW_ENTITIES(Map message){
    if(message['type'] == 'newEntities'){
      return true;
    }
    return false;
  }

  static bool isCOMBAT_SYNC_STATE(Map message){
    if(message['type'] == 'combatSyncState'){
      return true;
    }
    return false;
  }

  static bool isCLIENT_ID(Map message){
    if(message['type'] == 'clientID'){
      return true;
    }
    return false;
  }

  static bool isPLAYERS_ENTERED_INSTANCE(Map message){
    if(message['type'] == 'players_entered_instance'){
      return true;
    }
    return false;
  }
  static bool isENTITIES_ENTERED_INSTANCE(Map message){
    if(message['type'] == 'entities_entered_instance'){
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

  static isCLOSE_CONNECTION(Map message){  //DELETE may not need the close connection type!
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
    if(message['type'] == 'newEntity'){
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

  static bool isNEW_CLIENT(Map message){
    if(message['type'] == 'newClient'){
      return true;
    }
    return false;
  }


}


class Vector{
  double x,y;

  Point head, tail;

  Vector(this.x, this.y, [Vector start]){
    if(start != null){
      head = new Point(start.x, start.y);
      tail = new Point(head.x + x, head.y + y);
    }
  }


  operator +(Vector other) => new Vector(x + other.x, y + other.y);
  operator -(Vector other) => new Vector(x - other.x, y - other.y);
  operator *(num scalar) => new Vector(x * scalar, y * scalar);
  operator /(Vector other) => new Vector(x / other.x, y / other.y);
  operator ==(Vector other) => this.x == other.x && this.y == other.y;

  Vector copy(){
    return new Vector(this.x, this.y);
  }
  bool isZero(){
    return (x == 0.0 && y == 0.0);
  }
  void zero(){
    x = 0.0;
    y = 0.0;
  }
  Vector negate(){
    return new Vector(x * -1, y * -1);
  }

  Vector normalize(){
    double mag = magnitude();
    return new Vector(x / mag, y / mag);
  }

  double magnitude(){
    return sqrt(x * x + y * y);
  }

  toString(){
    return "[x:$x y:$y]";
  }
}

num abs(num n){
  if(n.isNegative){
    return n * -1;
  }
  return n;
}


num degreesToRadians(num degrees){
  return degrees * PI / 180;
}


Map genMessage(String type, Object data, [String clientID]){
  if(clientID == null){
    return {'type':type, 'data':data};
  }
  return {'type':type, 'clientID':clientID, 'data':data};
}

void webSocketSendToServer(webSocket, String typeOfMessage, String data, String ID){
  webSocket.send(JSON.encode(genMessage(typeOfMessage, data, ID)));
}

void webSocketSendToClients(pingClients,String typeOfMessage, Map data){
  pingClients.sink.add(JSON.encode(genMessage(typeOfMessage,data)));  //JSON encode maybe?
}

void webSocketSendToClient(pingClients, String ID,String typeOfMessage, Map data){
  pingClients.sink.add(JSON.encode(genMessage(typeOfMessage,data,ID)));  //JSON encode maybe?
}


class JSON_PARSER{
  static RegExp _POSITION_REGEX = new RegExp(r"\[(?:x\:)([0-9]+\.[0-9]+) (?:y\:)([0-9]+\.[0-9]+)\]");
  static Vector getPositionFromJson(Map json){
    var pos = _POSITION_REGEX.allMatches(json['position']).toList();
    return new Vector(double.parse(pos[0][1]), double.parse(pos[0][2]));
  }
}





