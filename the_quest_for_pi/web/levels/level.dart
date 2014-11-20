library levels;

import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'package:the_quest_for_pi/globals.dart' show MessageTypes, objectToMessage, serialization, messageToObject;
import 'package:the_quest_for_pi/levels/level.dart';
import '../entities/entity.dart';
import 'dart:async';
import '../main.dart' show ID, websocketSend, webSocket;

import 'package:the_quest_for_pi/entities/shared_entity.dart' show SharedEntity;

part 'level1.dart';

ResourceManager resourceManager = new ResourceManager();


abstract class Level extends SharedLevel{
  Level(List<String> assetsToLoad){
    for(num i = 0; i < assetsToLoad.length; i++){
      resourceManager.addBitmapData(assetsToLoad[i], 'assets/images/${assetsToLoad[i]}.png');
    }
    resourceManager.load().then((result){
      Timer waitTillWebSocketDone = new Timer(new Duration(seconds: 0), _webSocketDone);  //this could throw an error if websocket is not done in time!
      //TODO change to async when feature becomes available to make it deterministic ^^
    });
  }
  _webSocketDone(){
    init();
  }


  void updateSprites(num time){
    SharedEntity.entityManager.forEach((entity) => entity.updateAllComponents(time));
  }
}

