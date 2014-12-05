part of client_component;

class AnimationStates{ //TODO turn this into an enum when the proper time comes
  static final String IDLE_S    = 'idle_s',
                      WALKING_S = 'walking_s';
}

abstract class WizardAnimation implements Sprite, Entity{
  static final TextureAtlas
  _textureAtlas = GameWorld.resourceManager.getTextureAtlas('mageAnimation0');

  static final List<BitmapData>
  _walkSouthBitmapData = _textureAtlas.getBitmapDatas('walking s000'),
  _walkEastBitmapData = _textureAtlas.getBitmapDatas('walking e000'),
  _walkNorthBitmapData = _textureAtlas.getBitmapDatas('walking n000'),
  _walkWestBitmapData = _textureAtlas.getBitmapDatas('walking w000'),
  _idleWizardAnimation = _textureAtlas.getBitmapDatas('idle 0000');

  final FlipBook
  flipBookWizardAnimationIdle      = new FlipBook(_idleWizardAnimation),
  flipBookWizardAnimationWalkSouth = new FlipBook(_walkSouthBitmapData),
  flipBookWizardAnimationWalkNorth      = new FlipBook(_walkNorthBitmapData),
  flipBookWizardAnimationWalkEast = new FlipBook(_walkEastBitmapData),
  flipBookWizardAnimationWalkWest      = new FlipBook(_walkWestBitmapData);



  initWizardAnimation(){
    removeChild(idleStillPic);
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
    _handleAnimation(flipBookWizardAnimationIdle);
  }
  void _wizardWalkSouth(){
    _handleAnimation(flipBookWizardAnimationWalkSouth);

  }
  void _wizardWalkWest() {
    _handleAnimation(flipBookWizardAnimationWalkWest);
  }

  void _wizardWalkEast() {
    _handleAnimation(flipBookWizardAnimationWalkEast);
  }

  void _wizardWalkNorth() {
    _handleAnimation(flipBookWizardAnimationWalkNorth);
  }

  void _handleAnimation(FlipBook anime){  //TODO if you ever add another display object to this sprite this will explode DONT FORGET
    if(!this.contains(anime)){
      if(this.numChildren > 0){
        for(var i = 0; i < this.numChildren; i++){
          if(this.getChildAt(i) is FlipBook){
            this.removeChildAt(i);
          }
        }
      }
      this.addChild(anime);
    }

    anime..x = -20 ..y = - 20 .. gotoAndPlay(currentAnimationFrame);



  }

}