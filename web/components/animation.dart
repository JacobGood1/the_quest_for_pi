part of client_component;

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
  flipBookWizardAnimationWalkNorth = new FlipBook(_walkNorthBitmapData),
  flipBookWizardAnimationWalkEast  = new FlipBook(_walkEastBitmapData),
  flipBookWizardAnimationWalkWest  = new FlipBook(_walkWestBitmapData);



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

abstract class GoblinAnimation implements Sprite, Entity{
  static final TextureAtlas
  _textureAtlas = GameWorld.resourceManager.getTextureAtlas('goblin');

  static final List<BitmapData>
  _walkSouthBitmapData = _textureAtlas.getBitmapDatas('goblin walk s00'),
  _walkEastBitmapData = _textureAtlas.getBitmapDatas('goblin walk e00'),
  _walkNorthBitmapData = _textureAtlas.getBitmapDatas('goblin walk n00'),
  _walkWestBitmapData = _textureAtlas.getBitmapDatas('goblin walk w000'),
  _idleGoblinAnimation = _textureAtlas.getBitmapDatas('green gnome treffer s000');

  final FlipBook
  flipBookGoblinAnimationIdle      = new FlipBook(_idleGoblinAnimation),
  flipBookGoblinAnimationWalkSouth = new FlipBook(_walkSouthBitmapData),
  flipBookGoblinAnimationWalkNorth = new FlipBook(_walkNorthBitmapData),
  flipBookGoblinAnimationWalkEast  = new FlipBook(_walkEastBitmapData),
  flipBookGoblinAnimationWalkWest  = new FlipBook(_walkWestBitmapData);



  initGoblinAnimation(){
    removeChild(idleStillPic);
  }

  updateGoblinAnimation(num time){

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
    _handleAnimation(flipBookGoblinAnimationIdle);
  }
  void _wizardWalkSouth(){
    _handleAnimation(flipBookGoblinAnimationWalkSouth);

  }
  void _wizardWalkWest() {
    _handleAnimation(flipBookGoblinAnimationWalkWest);
  }

  void _wizardWalkEast() {
    _handleAnimation(flipBookGoblinAnimationWalkEast);
  }

  void _wizardWalkNorth() {
    _handleAnimation(flipBookGoblinAnimationWalkNorth);
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