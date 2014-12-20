part of client_entity;

final TextureAtlas fireball_explosionTA = main.currentGameWorld.resourceManager.getTextureAtlas('fireball_explosion'),
                   fireball_loopTA      = main.currentGameWorld.resourceManager.getTextureAtlas('fireball_loop'),
                   fireball_startTA     = main.currentGameWorld.resourceManager.getTextureAtlas('fireball_start');


class FireBall extends Entity{
  var fireBallCounter = 0, resetCounter = 0.0, fireBallPhase1 = true, fireBallPhase2 = true, fireBallPhase3 = true;
        FlipBook fireball_explosion,
                 fireball_loop,
                 fireball_start;

  FireBall(double posX, double posY, String ID) : super('FireBall', posX, posY, ID){
    fireball_explosion = new FlipBook(fireball_explosionTA.getBitmapDatas('00'), 15);
    fireball_loop = new FlipBook(fireball_loopTA.getBitmapDatas('00'));
    fireball_start = new FlipBook(fireball_startTA.getBitmapDatas('00'));
    main.currentGameWorld.stage.addChild(fireball_start..x = position.x - 50..y = position.y - 100);
    main.currentGameWorld.stage.addChild(fireball_explosion..visible = false..x = position.x..y = position.y - 100);
    main.currentGameWorld.stage.addChild(fireball_loop..visible = false..x = position.x..y = position.y - 100);
    main.currentGameWorld.addEntity(this);
    componentCombatModeFunctionList.add(updateFireBall);
  }
  updateFireBall(num time){
    fireball_loop..x = position.x - 50..y = position.y - 100;
    if(fireBallPhase1){
      fireball_start.gotoAndPlay(fireBallCounter);
    } else if(fireBallPhase2){
      if(main.currentGameWorld.stage.contains(fireball_start)){
        main.currentGameWorld.stage.removeChild(fireball_start);
      }
      fireball_loop.visible = true;
      fireball_loop.gotoAndPlay(fireBallCounter);
    } else if(fireBallPhase3){
      if(main.currentGameWorld.stage.contains(fireball_loop)){
        fireball_explosion.x = position.x;
        main.currentGameWorld.stage.removeChild(fireball_loop);
      }
      fireball_explosion.visible = true;
      fireball_explosion.gotoAndPlay(fireBallCounter);
    }

  }

  void extractData(Map entity){
    this
      ..ID = entity['ID']
      ..position.x = entity['positionX']
      ..position.y = entity['positionY']
      ..isDead = entity['isDead']
      ..fireBallCounter = entity['fireBallCounter']
      ..resetCounter = entity['resetCounter']
      ..fireBallPhase1 = entity['fireBallPhase1']
      ..fireBallPhase2 = entity['fireBallPhase2']
      ..fireBallPhase3 = entity['fireBallPhase3'];
  }
}