library levels;


import 'dart:convert';
import 'package:the_quest_for_pi/globals.dart' show MessageTypes, objectToMessage, messageToObject;
import 'package:the_quest_for_pi/levels/level.dart';
import '../entities/entity.dart';
import 'dart:async';
import '../server.dart';

part 'level1.dart';



abstract class Level {

  void updateSprites(num time){
    playerEntities.forEach((player) => player.updateAllComponents(time));
    serverEntities.forEach((entity) => entity.updateAllComponents(time));
  }
}

