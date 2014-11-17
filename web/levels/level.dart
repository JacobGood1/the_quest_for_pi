library levels;

import 'package:stagexl/stagexl.dart';
import 'package:the_quest_for_pi_production/levels/level.dart';
import '../entities/entity.dart';

part 'level1.dart';

ResourceManager resourceManager = new ResourceManager();

abstract class Level extends SharedLevel{
  Level(List<String> assetsToLoad){
    for(num i = 0; i < assetsToLoad.length; i++){
      resourceManager.addBitmapData(assetsToLoad[i], 'assets/images/${assetsToLoad[i]}.png');
    }
    resourceManager.load().then((result){
      init();
    });
  }

  void updateSprites(num time){
    entityManager.forEach((entity) => entity.updateAllComponents(time));
  }
}

