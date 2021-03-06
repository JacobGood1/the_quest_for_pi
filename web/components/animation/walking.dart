part of client_component;

abstract class WizardAnimation implements stage.Sprite, Entity{
  static final stage.TextureAtlas
    _textureAtlas1 = main.currentGameWorld.resourceManager.getTextureAtlas('mageAnimation0');

  static final stage.TextureAtlas
    _textureAtlas2 = main.currentGameWorld.resourceManager.getTextureAtlas('mageAnimation1');

  static final List<stage.BitmapData>
    _walkSouthBitmapData = _textureAtlas1.getBitmapDatas('walking s000'),
    _walkEastBitmapData = _textureAtlas1.getBitmapDatas('walking e000'),
    _walkNorthBitmapData = _textureAtlas1.getBitmapDatas('walking n000'),
    _walkWestBitmapData = _textureAtlas1.getBitmapDatas('walking w000'),
    _idleWizardAnimation = _textureAtlas1.getBitmapDatas('idle 000'),  //TODO turn back to IDLE when done
    _idleWizardCombatAnimation = _textureAtlas1.getBitmapDatas('idle 0002');

  final stage.FlipBook
  flipBookWizardAnimationIdle       = new stage.FlipBook(_idleWizardAnimation),
  flipBookWizardAnimationIdleCombat = new stage.FlipBook(_idleWizardCombatAnimation),
  flipBookWizardAnimationWalkSouth  = new stage.FlipBook(_walkSouthBitmapData),
  flipBookWizardAnimationWalkNorth  = new stage.FlipBook(_walkNorthBitmapData),
  flipBookWizardAnimationWalkEast   = new stage.FlipBook(_walkEastBitmapData),
  flipBookWizardAnimationWalkWest   = new stage.FlipBook(_walkWestBitmapData);



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
      case 'idle_combat':
        _wizardIdleCombat();
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
  void _wizardIdleCombat() {
    _handleAnimation(flipBookWizardAnimationIdleCombat);
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

  void _handleAnimation(stage.FlipBook anime){  //TODO if you ever add another display object to this sprite this will explode DONT FORGET
    if(!this.contains(anime)){
      if(this.numChildren > 0){
        for(var i = 0; i < this.numChildren; i++){
          if(this.getChildAt(i) is stage.FlipBook){
            this.removeChildAt(i);
          }
        }
      }
      this.addChild(anime);
    }

    anime..x = -20 ..y = - 20 .. gotoAndPlay(currentAnimationFrame);
  }
}



abstract class GoblinAnimation implements stage.Sprite, Entity{
  static final stage.TextureAtlas
  _textureAtlas = main.currentGameWorld.resourceManager.getTextureAtlas('goblin');

  static final List<stage.BitmapData>
  _attackRightGoblin = _textureAtlas.getBitmapDatas('attack e000'),
  _walkSouthBitmapData = _textureAtlas.getBitmapDatas('goblin walk s00'),
  _walkEastBitmapData = _textureAtlas.getBitmapDatas('goblin walk e00'),
  _walkNorthBitmapData = _textureAtlas.getBitmapDatas('goblin walk n00'),
  _walkWestBitmapData = _textureAtlas.getBitmapDatas('goblin walk w000'),
  _idleGoblinAnimation = _textureAtlas.getBitmapDatas('green gnome treffer s000'),
  _idleGoblinCombatAnimation = _textureAtlas.getBitmapDatas('green gnome treffer e000');

  final stage.FlipBook
  flipBookGoblinAttackRight         = new stage.FlipBook(_attackRightGoblin),
  flipBookGoblinAnimationIdle       = new stage.FlipBook(_idleGoblinAnimation),
  flipBookGoblinAnimationIdleCombat = new stage.FlipBook(_idleGoblinCombatAnimation),
  flipBookGoblinAnimationWalkSouth  = new stage.FlipBook(_walkSouthBitmapData),
  flipBookGoblinAnimationWalkNorth  = new stage.FlipBook(_walkNorthBitmapData),
  flipBookGoblinAnimationWalkEast   = new stage.FlipBook(_walkEastBitmapData),
  flipBookGoblinAnimationWalkWest   = new stage.FlipBook(_walkWestBitmapData);



  initGoblinAnimation(){
    removeChild(idleStillPic);
  }

  updateGoblinAnimation(num time){
    switch (currentAnimationState){
      case 'attacking':
        _goblinAttack();
        break;
      case 'walking_s':
        _goblinWalkSouth();
        break;
      case 'idle_combat':
        _goblinIdleCombat();
        break;
      case 'idle_s':
        _goblinIdle();
        break;
      case 'walking_n':
        _goblinWalkNorth();
        break;
      case 'walking_e':
        _goblinWalkEast();
        break;
      case 'walking_w':
        _goblinWalkWest();
        break;
    }
  }

  void _goblinAttack() {
    _handleAnimation(flipBookGoblinAttackRight);
  }
  void _goblinIdle() {
    _handleAnimation(flipBookGoblinAnimationIdle);
  }
  void _goblinWalkSouth(){
    _handleAnimation(flipBookGoblinAnimationWalkSouth);

  }
  void _goblinWalkWest() {
    _handleAnimation(flipBookGoblinAnimationWalkWest);
  }

  void _goblinWalkEast() {
    _handleAnimation(flipBookGoblinAnimationWalkEast);
  }

  void _goblinWalkNorth() {
    _handleAnimation(flipBookGoblinAnimationWalkNorth);
  }
  void _goblinIdleCombat(){
    _handleAnimation(flipBookGoblinAnimationIdleCombat);
  }

  void _handleAnimation(stage.FlipBook anime){  //TODO if you ever add another display object to this sprite this will explode DONT FORGET
    if(!this.contains(anime)){
      if(this.numChildren > 0){
        for(var i = 0; i < this.numChildren; i++){
          if(this.getChildAt(i) is stage.FlipBook){
            this.removeChildAt(i);
          }
        }
      }
      this.addChild(anime);
    }

    anime..x = -20 ..y = - 20 .. gotoAndPlay(currentAnimationFrame);
  }

}