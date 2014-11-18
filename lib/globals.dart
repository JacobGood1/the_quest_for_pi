
int spriteWidth = 50, spriteHeight = 50;
int canvasWidth = 1000, canvasHeight = 1000;

class MessageTypes{
  static String ID = 'clientID';
  static String NEW_PLAYER = 'newPlayer';
  //static String ID = 'clientID';

  static getData(Map message){
    return message['data'];
  }

  static bool isID(Map message){
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
}
