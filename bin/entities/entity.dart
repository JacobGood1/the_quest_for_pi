library entity;

import 'dart:mirrors';

import 'package:the_quest_for_pi/globals.dart';
import 'package:the_quest_for_pi/components/shared_component.dart';
import 'package:the_quest_for_pi/entities/shared_entity.dart';
import '../components/component.dart';

//player
part 'player.dart';

//humanoids
part 'humanoids/humans/humans.dart';

//flying creatures
part 'flying_creatures/flying_creature.dart';
part 'flying_creatures/bat.dart';


abstract class Entity extends SharedEntity{


  Entity(String assetName, num startX, num startY){
    lookAtMe = reflect(this);

    position = new Vector(startX, startY);
    addAllComponentInformation(this);
  }
}

