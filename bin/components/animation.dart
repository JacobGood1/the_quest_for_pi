part of server_component;


class AnimationStates {
  //TODO turn this into an enum when the proper time comes
  static String
  IDLE_S = 'idle_s',
  WALKING_S = 'walking_s',
  WALKING_N = 'walking_n',
  WALKING_E = 'walking_e',
  WALKING_W = 'walking_w';
}
//testing
abstract class WizardAnimation implements InputManager, Entity{
  double _animationSwitchWizardAnimation = 0.0;
  updateWizardAnimation(num time){
    if(!isAnyKeyDown()){
      currentAnimationState = AnimationStates.IDLE_S;
    } else if(isKeyBeingPressed('s')){
      currentAnimationState = AnimationStates.WALKING_S;
    } else if(isKeyBeingPressed('w')){
      currentAnimationState = AnimationStates.WALKING_N;
    } else if(isKeyBeingPressed('a')){
      currentAnimationState = AnimationStates.WALKING_W;
    }else if(isKeyBeingPressed('d')){
      currentAnimationState = AnimationStates.WALKING_E;
    }

    _animationSwitchWizardAnimation += time;
    if(_animationSwitchWizardAnimation >= 0.045){
      _animationSwitchWizardAnimation = 0.0;
      currentAnimationFrame++;
      if(currentAnimationFrame > 8){
        currentAnimationFrame = 0;
      }
    }
  }
}