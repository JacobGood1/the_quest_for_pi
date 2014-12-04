part of client_component;


bool _justStartedWizardAnimation = true;

class AnimationStates{ //TODO turn this into an enum when the proper time comes
  static final String IDLE_S    = 'idle_s',
                      WALKING_S = 'walking_s';
}

abstract class WizardAnimation implements Sprite, Entity, Collision_AABB{
  TextureAtlas _textureAtlas = GameWorld.resourceManager.getTextureAtlas('mageAnimation0');
  String currentState = '';
  FlipBook flipBookWizardAnimation;
  var _walkSouthBitmapData,
  _idleWizardAnimation,
  _walkEastBitmapData,
  _walkNorthBitmapData,
  _walkWestBitmapData;

  initWizardAnimation(){
    removeChild(idleStillPic);
    _walkSouthBitmapData = _textureAtlas.getBitmapDatas('walking s000');
    _walkEastBitmapData = _textureAtlas.getBitmapDatas('walking e000');
    _walkNorthBitmapData = _textureAtlas.getBitmapDatas('walking n000');
    _walkWestBitmapData = _textureAtlas.getBitmapDatas('walking w000');
    _idleWizardAnimation = _textureAtlas.getBitmapDatas('idle 0000');
  }

  updateWizard(num time){
    switch (currentAnimationState){
      case 'walking_s':
        _wizardWalkSouth();
        break;
      case 'idle_s':
        _wizardIdle();
        break;
      case 'walking_n':
        _wizardWalkNorth();
        break;
      case 'walking_e':
        _wizardWalkEast();
        break;
      case 'walking_w':
        _wizardWalkWest();
        break;
    }
  }

  void _wizardIdle() {
    flipBookWizardAnimation = new FlipBook(_idleWizardAnimation)
      ..gotoAndPlay(0)
      ..x = -20
      ..y = -20
      ..addTo(this);
  }
  void _wizardWalkSouth(){
    flipBookWizardAnimation = new FlipBook(_walkSouthBitmapData)
      ..gotoAndPlay(currentAnimationFrame)
      ..x = -20
      ..y = -20
      ..addTo(this);
  }
  void _wizardWalkWest() {
    flipBookWizardAnimation = new FlipBook(_walkWestBitmapData)
      ..gotoAndPlay(currentAnimationFrame)
      ..x = -20
      ..y = -20
      ..addTo(this);
  }

  void _wizardWalkEast() {
    flipBookWizardAnimation = new FlipBook(_walkEastBitmapData)
      ..gotoAndPlay(currentAnimationFrame)
      ..x = -20
      ..y = -20
      ..addTo(this);
  }

  void _wizardWalkNorth() {
    flipBookWizardAnimation = new FlipBook(_walkNorthBitmapData)
      ..gotoAndPlay(currentAnimationFrame)
      ..x = -20
      ..y = -20
      ..addTo(this);
  }

  void _stopAllAnimation(){
    flipBookWizardAnimation..stop..removeFromParent();
  }

}