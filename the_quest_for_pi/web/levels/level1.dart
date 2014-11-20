part of levels;

class Level1 extends Level{
  Stage stage;

  Level1(this.stage):super(['black_mage', 'bat', 'bush']) {
  }

  void init() {
    var maggy = new Player(ID ,100.0,100.0);

    var batty = new Bat(200.0, 200.0);
    //var bush = new Bush(500.0, 500.0);
    stage.addChild(maggy);
    stage.addChild(batty.colliderDebug);
    stage.addChild(batty);

    //stage.addChild(bush);
    /*
    TODO find a way to send a message to the server that tells it to create a player!
         tried serialization but it did not work, add types to MessageType that helps
         server parse the message being sent, take message and create a player on the server
    */
    //websocketSend(MessageTypes.NEW_PLAYER, 'player plox werk?');//TODO DONT EFFING FORGET FGT.
  }
}