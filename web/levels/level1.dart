part of levels;

class Level1 extends Level{
  Stage stage;

  Level1(this.stage):super(['black_mage', 'bat']) {
  }

  void init() {
    var maggy = new Player(ID ,100.0,100.0);
    var batty = new Bat(200.0, 200.0);
    entityManager.add(maggy);
    stage.addChild(maggy);
    //stage.addChild(batty);
    /*
    TODO find a way to send a message to the server that tells it to create a player!
         tried serialization but it did not work, add types to MessageType that helps
         server parse the message being sent, take message and create a player on the server
    */

  }
}

