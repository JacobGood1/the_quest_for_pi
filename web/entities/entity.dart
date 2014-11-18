library entity;

import 'dart:mirrors';
import 'package:stagexl/stagexl.dart' show Sprite, Bitmap;

import 'package:the_quest_for_pi/globals.dart';
import 'package:the_quest_for_pi/components/shared_component.dart';
import 'package:the_quest_for_pi/entities/shared_entity.dart';
import '../components/component.dart';
import '../levels/level.dart' show resourceManager;
import '../main.dart' show websocketSend;

part 'humanoids/humans/humans.dart';
part 'player.dart';

List<Entity> entityManager = [];

abstract class Entity extends Sprite with SharedEntity{
  List <Type> _rulesSoFar = [];
  Bitmap _appearance;

  Entity(String assetName, num startX, num startY){

    if(!_rulesSoFar.contains(this.runtimeType)){  //add rules for serialization only if this object has not been used before
      serialization.addRuleFor(this.runtimeType, constructor: "", fields: ["position"]);
      _rulesSoFar.add(this.runtimeType);
    }

    lookAtMe = reflect(this);
    if(!(assetName == '')){
      _appearance = new Bitmap(resourceManager.getBitmapData(assetName));
      pivotX = _appearance.width / 2;
      pivotY = _appearance.height / 2;

      this.addChild(_appearance);
      entityManager.add(this);
    }

    position = new Vector(startX, startY);
    addAllComponentInformation(this);
  }
}

