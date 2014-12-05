part of client_component;

class SoundStates{
  static String FOOTSTEP = 'footstep';
  static String IDLE = 'idle';
}


abstract class FootStep implements Entity{
  static final Sound _soundFootStep = GameWorld.resourceManager.getSound("footstep");
  static final SoundTransform soundTransform = new SoundTransform(0.6);
  Stopwatch timeFootStep = new Stopwatch();
  void updateFootStep(num time){
      if(currentSoundState == SoundStates.FOOTSTEP){
        if(!timeFootStep.isRunning){
          timeFootStep.start();
          _soundFootStep.play(false, soundTransform);
        }else if(timeFootStep.elapsedMilliseconds > 400){
          timeFootStep..stop()..reset();
        }
      }
  }
}