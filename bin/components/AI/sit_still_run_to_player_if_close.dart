part of server_component;

abstract class SitStillRunToPlayerIfCloseOrStar implements Movement, Entity{
  double timerSitStillRunToPlayerIfClose = 0.0;

  updateSitStillRunToPlayerIfClose(num time){
    if(timerSitStillRunToPlayerIfClose >= 0.45){
      Player closestPlayer;
      Entity closestFight;
      double closestDistanceToPlayer, closestDistanceToFight;
      var currentlyMoving = false;
      //determine the player that is closest to the ai
      inWhatInstance.playerEntities.forEach((Player player) {
        double distance = distanceTo(this, player);
        if(closestPlayer == null){
          closestPlayer = player;
          closestDistanceToPlayer = distance;
        }else if(distance <= closestDistanceToPlayer){
          closestDistanceToPlayer = distance;
          closestPlayer = player;
        }
      });

      //search the map for current fights and join them if they are close enough
      inWhatInstance.entities.forEach((Entity entity) {
        if(entity is CombatStar){
          double distance = distanceTo(this, entity);
          if(closestFight == null){
            closestFight = entity;
            closestDistanceToFight = distance;
          }else if(distance <= closestDistanceToFight){
            closestDistanceToFight = distance;
            closestFight = entity;
          }
        }
      });

      if(closestPlayer != null && closestDistanceToFight != null){
        if(closestDistanceToPlayer <= closestDistanceToFight){
          currentlyMoving = _moveIfCloseEnough(closestPlayer, closestDistanceToPlayer);
        } else {
          currentlyMoving = _moveIfCloseEnough(closestFight, closestDistanceToFight);
        }
      } else{
        //once a player joins closest player will no longer be null, move towards that player if they are close enough
        if(closestPlayer != null){
          currentlyMoving = _moveIfCloseEnough(closestPlayer, closestDistanceToPlayer);
        }
        //once a fight starts closest fight will no longer be null, move towards that fight if it is close enough
        if(closestFight != null){
          currentlyMoving = _moveIfCloseEnough(closestFight, closestDistanceToFight);
        }
      }

      if(!currentlyMoving){
        stopMoving();
      }

      timerSitStillRunToPlayerIfClose = 0.0;
    }
    timerSitStillRunToPlayerIfClose+=time;
  }

  bool _moveIfCloseEnough(Entity ent, double distance){
    if(distance <= 100000) {
      moveToward(ent);
      return true;
    }
    return false;
  }
}