part of server_component;

abstract class SitStillRunToPlayerIfClose implements Movement, Entity{
  updateSitStillRunToPlayerIfClose(num time){
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

    moveToward(closestPlayer);


  }
}

double distanceToAI(Vector self, Vector other){
  return (other.x - self.x) * (other.x - self.x) + (other.y - self.y) * (other.y - self.y);
}