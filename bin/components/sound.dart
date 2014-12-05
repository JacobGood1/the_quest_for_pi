part of server_component;

class SoundStates{
  static String FOOTSTEP = 'footstep';
  static String IDLE = 'idle';
}

abstract class FootStep implements Entity{
  Vector _lastPositionFootStep;

  initFootStep(){
    _lastPositionFootStep = position.copy();
  }

  void updateFootStep(num time){

    if(position == _lastPositionFootStep){
      currentSoundState = SoundStates.IDLE;
    } else{
      currentSoundState = SoundStates.FOOTSTEP;
    }
    _lastPositionFootStep = position.copy();

  }
}