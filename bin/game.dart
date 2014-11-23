part of server;

Set<String> clientIDs = new Set();
Map<String, Player> clients = {};
Map<String, List<String>> clientInput = {};
List<Entity> serverEntities = [];
List<Player> playerEntities = []; // String == ID

Level currentLevel;

//client input comes in as {type ID input}
/*handleClientInput(){
  clientInput.forEach((Map currentClient){
    var clientID = currentClient.keys.first,
        currentKeyPresses = currentClient.values.first;

    clients[clientID].currentKeys(currentKeyPresses);  //handle the key presses!
    print('clients: $clients ');
  } ); //update the player with these new kewl thingies
}*/

class PhysicsState{
  GameLoopIsolate physicsLoop = new GameLoopIsolate();
  PhysicsState(){
    physicsLoop.onUpdate = ((physicsLoop) {
      currentLevel.updateSprites(physicsLoop.dt);

    // Update game logic here.
      //print('${physicsLoop.frame}: ${physicsLoop.gameTime} [dt = ${physicsLoop.dt}].');

    });
  }
}


class ServerState{
  double SERVERTICK = 0.045,
         reset = 0.0;
  GameLoopIsolate serverLoop = new GameLoopIsolate();
  ServerState(WebSocket ws){
    serverLoop.onUpdate = ((serverLoop) {
      reset += serverLoop.dt;
      if(reset >= SERVERTICK){
        reset = 0.0;
        if(ws != null){
        //send all entity updates back to the client, this is authoritative

        }
      }

    });
  }

}








