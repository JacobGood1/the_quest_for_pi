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
abstract class WizardAnimation implements InputManager, Entity{
  double _animationSwitchWizardAnimation = 0.0;
  Vector _lastWizardAnimationPosition;
  initWizardAnimation(){
   _lastWizardAnimationPosition = position.copy();
  }

  updateWizardAnimation(num time){
    if(position == _lastWizardAnimationPosition){
      currentAnimationState = AnimationStates.IDLE_S;
      _animationSwitchWizardAnimation = 0.0;
      currentAnimationFrame = 0;
    } else if(position.y > _lastWizardAnimationPosition.y){
      currentAnimationState = AnimationStates.WALKING_S;
    } else if(position.y < _lastWizardAnimationPosition.y){
      currentAnimationState = AnimationStates.WALKING_N;
    } else if(position.x < _lastWizardAnimationPosition.x){
      currentAnimationState = AnimationStates.WALKING_W;
    }else if(position.x > _lastWizardAnimationPosition.x){
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
    _lastWizardAnimationPosition = position.copy();
  }
}