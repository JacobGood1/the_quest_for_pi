part of server_component;

abstract class SitStillRunToPlayerIfClose implements Movement, Entity{
  double timerSitStillRunToPlayerIfClose = 0.0;

  updateSitStillRunToPlayerIfClose(num time){
    if(timerSitStillRunToPlayerIfClose >= 0.45){
      Player closestPlayer = new Player(0.0,0.0);
      double closestDistance;
      GameWorld.playerEntities.forEach((Player player) {
        var distance = distanceToAI(this.position, player.position);
        if(closestDistance == null){
          closestDistance = distance;
          closestPlayer = player;
        } else{
          if(distance <= closestDistance){
            closestPlayer = player;
          }
        }
      });
      if(closestDistance != null){
        if(!(closestDistance > 100000)){
          moveToward(closestPlayer);
        }
        else {
          stopMoving();
        }
      }
      timerSitStillRunToPlayerIfClose = 0.0;
    }
    timerSitStillRunToPlayerIfClose+=time;
  }
}