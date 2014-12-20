part of server_entity;


class FireBall extends Entity with Collision_AABB, Movement{
  var fireBallCounter = 0, resetCounter = 0.0, fireBallPhase1 = true, fireBallPhase2 = false, fireBallPhase3 = false;
  Entity goingToward;
  FireBall(double posX, double posY, inWhichInstance, Entity this.goingToward) : super(posX, posY){
    inWhatInstance = inWhichInstance;
    componentCombatModeFunctionList.add(updateFireBallAnimationSpeed);
    type = 'FireBall';
    movementSpeed = 5.0;
  }
  var lastPostionFireBall = new Vector(10000.0,0.0);
  updateFireBallAnimationSpeed(num time){
    resetCounter+=time;
    if(lastPostionFireBall.x < position.x){
      fireBallPhase1 = false;
      fireBallPhase2 = false;
      fireBallPhase3 = true;
    }
    else{
      lastPostionFireBall = position.copy();
      if(resetCounter >= 0.2){
        fireBallCounter++;
        resetCounter = 0.0;
        if(fireBallPhase1){
          if(fireBallCounter >= 7){
            fireBallCounter = 0;
            fireBallPhase1 = false;
            fireBallPhase2 = true;
          }
        } else if(fireBallPhase2){
          moveToward(goingToward);
          if(fireBallCounter >= 11){
            fireBallCounter = 0;
          }
        }
      }
      position += velocity.copy();
    }
    if(fireBallPhase3){
      if(resetCounter >= 0.1){
        resetCounter = 0.0;
        if(fireBallCounter >= 11){
          inWhatInstance.removeEntity(this);
          (goingToward as Goblin).reduceHealth(100);
          fireBallPhase3 = false;
        }
        fireBallCounter++;
      }
    }
  }
  fireBallStart(){
  }
  fireBallFlight(){

  }
  fireBallExplosion(){

  }

  Map toJson(){
    return
      {
          'ID': this.ID,
          'positionX': this.position.x,
          'positionY': this.position.y,
          'type': this.type,
          'currentAnimationState': this.currentAnimationState,
          'currentAnimationFrame': this.currentAnimationFrame,
          'currentSoundState': this.currentSoundState,
          'isDead': this.isDead,
          'inCombat': this.inCombat,
          'fireBallCounter': this.fireBallCounter,
          'resetCounter': this.resetCounter,
          'fireBallPhase1': this.fireBallPhase1,
          'fireBallPhase2': this.fireBallPhase2,
          'fireBallPhase3': this.fireBallPhase3
      };
  }

}