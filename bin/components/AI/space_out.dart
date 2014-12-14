part of server_component;

abstract class SpaceOut implements Movement, Entity{
  double _timerSpaceOut = 0.0;

  updateSpaceOut(num time){
    if(_timerSpaceOut >= 0.45){
      Entity closestEntity = new Goblin(0.0,0.0);
      double closestEnemyDistance;
      gameWorld.entities.forEach((Entity entity) {
        if(entity.type != 'Bush' && this.type != 'Bush'){
          if(this.ID != entity.ID){
            var distance = distanceTo(this, entity);
            if(closestEnemyDistance == null){
              closestEnemyDistance = distance;
              closestEntity = entity;
            } else{
              if(distance <= closestEnemyDistance){
                closestEntity = entity;
              }
            }
          }
        }
      });
      if(closestEnemyDistance != null){
        if(closestEnemyDistance < 1000){
          moveAway(closestEntity);
        }
      }

      _timerSpaceOut = 0.0;
    }
    _timerSpaceOut+=time;
  }
}

