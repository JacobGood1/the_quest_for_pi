library entity;

import 'dart:mirrors';
import 'dart:math' show Rectangle;
import 'package:stagexl/stagexl.dart' show Sprite, Bitmap;

import 'package:the_quest_for_pi/globals.dart';
import 'package:the_quest_for_pi/components/shared_component.dart';
import 'package:the_quest_for_pi/entities/shared_entity.dart';
import '../components/component.dart';
import '../levels/level.dart' show resourceManager;
import '../main.dart' show websocketSend;

//player
part 'humanoids/humans/humans.dart';
part 'player.dart';

//flying creatures
part 'flying_creatures/flying_creature.dart';
part 'flying_creatures/bat.dart';

//terrain
part 'terrain/terrain.dart';
part'terrain/bush.dart';

abstract class Entity extends Sprite with SharedEntity{

  Bitmap _appearance;

  Map swapScreen = {'currentScreen' : 'Level_1', //TODO Level_1 hardcoded for now
                    'swapScreen' : 'Battle'};

  Entity(String assetName, num startX, num startY){
    lookAtMe = reflect(this);
    if(!(assetName == '')){
      _appearance = new Bitmap(resourceManager.getBitmapData(assetName));
      pivotX = _appearance.width / 2;
      pivotY = _appearance.height / 2;

      this.addChild(_appearance);
      SharedEntity.entityManager.add(this);
    }

    position = new Vector(startX, startY);
    addAllComponentInformation(this);
  }

  SharedEntity attachEntity(){
    SharedEntity.entityManager.add(this);
    return this;
  }

  SharedEntity detachEntity(){
    SharedEntity.entityManager.remove(this);
    return this;
  }
}

