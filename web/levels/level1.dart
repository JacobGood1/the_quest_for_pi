part of levels;

class Level1 extends Level{
  Stage stage;

  var entitySize = 64.0;
  var entityOffset = 32.0; //size / 2.0;


  Map mapSymbols = {'#': (double x, double y){return new Bush(x, y);},
                    '@': (double x, double y){return new Bat(x, y);}, //bat for testing, this will be the icon for 'Next Screen'
                    'N': null};

  Map<String, List> mapLayout = {'Level_1': [
  ['#','#','#','#','#','#','#','#','#','#','#','#','#','#','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','N','@'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','N','@'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
  ['#','#','#','#','#','#','#','#','#','#','#','#','#','#','#']]};

  Level1(this.stage):super(['player', 'monster', 'bush']) {
  }

  void init() {


    var maggy = new Player(ID ,164.0,64 + 32.0);

    var batty = new Bat(400.0, 400.0);



    stage.addChild(maggy);
    //stage.addChild(batty.colliderDebug);
    stage.addChild(batty);

    this.constructTown();
    //Entity kek = maggy.detachEntity();
    //print(kek);
    //kek.attachEntity();
    SharedEntity.entityManager.forEach((e){
     //print(e.x);
    });
    /*
    TODO find a way to send a message to the server that tells it to create a player!
         tried serialization but it did not work, add types to MessageType that helps
         server parse the message being sent, take message and create a player on the server
    */

  }


  void constructTown(){
    double x = entityOffset;
    double y = entityOffset;
    this.mapLayout['Level_1'].forEach((l){
      l.forEach((s){
        if (this.mapSymbols[s] != null) {
          stage.addChild(mapSymbols[s](x, y));
          x += entitySize;
        } else {x += entitySize;}
      });
      x = entityOffset;
      y += entitySize;
    });
  }
}