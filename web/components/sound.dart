part of client_component;

class SoundStates{
  static String FOOTSTEP = 'footstep';
  static String IDLE = 'idle';
}


abstract class FootStep implements Entity{ //TODO footstep is playing multiple sounds
  final stage.Sound _soundFootStep = main.currentGameWorld.resourceManager.getSound("footstep");
  final stage.SoundTransform soundTransform = new stage.SoundTransform(0.6);
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