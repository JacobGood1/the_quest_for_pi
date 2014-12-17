part of server_component;


class AnimationStates {
  //TODO turn this into an enum when the proper time comes
  static String
  ATTACKING = 'attacking',
  IDLE_S = 'idle_s',
  IDLE_COMBAT = 'idle_combat',
  WALKING_S = 'walking_s',
  WALKING_N = 'walking_n',
  WALKING_E = 'walking_e',
  WALKING_W = 'walking_w';
}
abstract class WalkingAnimation implements Entity{
  double _animationSwitchWalkingAnimation = 0.0;
  Vector _lastWalkingAnimationPosition;
  initWalkingAnimation(){
   _lastWalkingAnimationPosition = position.copy();
  }

  updateWalkingAnimation(num time){
    if(position == _lastWalkingAnimationPosition){
      currentAnimationState = AnimationStates.IDLE_S;
      _animationSwitchWalkingAnimation = 0.0;
      currentAnimationFrame = 0;
    } else if(position.y > _lastWalkingAnimationPosition.y){
      currentAnimationState = AnimationStates.WALKING_S;
    } else if(position.y < _lastWalkingAnimationPosition.y){
      currentAnimationState = AnimationStates.WALKING_N;
    } else if(position.x < _lastWalkingAnimationPosition.x){
      currentAnimationState = AnimationStates.WALKING_W;
    }else if(position.x > _lastWalkingAnimationPosition.x){
      currentAnimationState = AnimationStates.WALKING_E;
    }

    _animationSwitchWalkingAnimation += time;
    if(_animationSwitchWalkingAnimation >= 0.045){
      _animationSwitchWalkingAnimation = 0.0;
      currentAnimationFrame++;
      if(currentAnimationFrame > 8){
        currentAnimationFrame = 0;
      }
    }
    _lastWalkingAnimationPosition = position.copy();
  }
}

abstract class WalkingGoblinAnimation implements Entity{
  double _animationSwitchWalkingAnimation = 0.0;

  static final List<double>
  _xRangeWalkingGoblinAnimation = new List(2)
    ..[0] = -30.0
    ..[1] = 30.0,
  _yRangeWalkingGoblinAnimation = new List(2)
    ..[0] = -30.0
    ..[1] = 30.0;

  updateWalkingAnimation(num time){
    if(velocity.isZero()){
      currentAnimationState = AnimationStates.IDLE_S;
      _animationSwitchWalkingAnimation = 0.0;
      currentAnimationFrame = 0;
    } else if(velocity.x.isNegative && _withinRangeYWalkingGoblinAnimation()){
      currentAnimationState = AnimationStates.WALKING_W;
    } else if(!velocity.x.isNegative && _withinRangeYWalkingGoblinAnimation()){
      currentAnimationState = AnimationStates.WALKING_E;
    } else if(velocity.y.isNegative && _withinRangeXWalkingGoblinAnimation()){
      currentAnimationState = AnimationStates.WALKING_N;
    }else if(!velocity.y.isNegative && _withinRangeXWalkingGoblinAnimation()){
      currentAnimationState = AnimationStates.WALKING_S;
    }

    _animationSwitchWalkingAnimation += time;
    if(_animationSwitchWalkingAnimation >= 0.045){
      _animationSwitchWalkingAnimation = 0.0;
      currentAnimationFrame++;
      if(currentAnimationFrame > 8){
        currentAnimationFrame = 0;
      }
    }
  }

  bool _withinRangeXWalkingGoblinAnimation(){
    return _xRangeWalkingGoblinAnimation[0] < velocity.x && velocity.x < _xRangeWalkingGoblinAnimation[1];
  }
  bool _withinRangeYWalkingGoblinAnimation(){
    return _yRangeWalkingGoblinAnimation[0] < velocity.y && velocity.y < _yRangeWalkingGoblinAnimation[1];
  }
}
