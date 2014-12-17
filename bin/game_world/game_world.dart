library server_game_world;

import '../server.dart' show MAIN_WORLD;
import 'package:http/http.dart' as http;
import '../entities/entity.dart';
import 'package:the_quest_for_pi/base_entity.dart';
import 'dart:math';
import 'package:the_quest_for_pi/globals.dart' show Vector;

part 'combat_world.dart';

//this will find the exact date of a DateTime.now() string by parsing out all the numbers
final RegExp dateTimeParse = new RegExp(r'([0-9]{4})\-([0-9]{2})\-([0-9]{2}) ([0-9]+)\:([0-9]+)\:([0-9]+)\.([0-9]*)');
final Random rng = new Random();


abstract class GameWorldContainer{
  String ID, type;
  List<Player> playerEntities;
  List<Entity> entities;

  //sends the entities that need to be added to the client, toJson should autoclear this
  List<Entity> entitiesToAdd = [];
  List<Player> playersToAdd = [];
  List<Entity> entitiesToRemove = [];
  List<Player> playersToRemove = [];

  GameWorldContainer(this.playerEntities, this.entities){
    this.ID = uuid.v4();
  }
  addCombatStar(e){
    entitiesToAdd.add(e);
  }
  void addEntity(Entity e){
    entitiesToAdd.add(e);
    e.inWhatInstance.entitiesToRemove.add(e);
    e.inWhatInstance = this;
    stageAddChild(e);
  }
  void addPlayer(Entity e){
    playersToAdd.add(e);
    e.inWhatInstance.playersToRemove.add(e);
    e.inWhatInstance = this;
    stageAddChild(e);
  }
  void removeEntity(Entity e){
    entitiesToRemove.add(e);
  }
  void removePlayer(Entity e){
    playersToRemove.add(e);
  }
  void stageAddChild(e){}

  Map toJson();
}


class GameWorld extends GameWorldContainer{
   var entitySize = 64.0;
   var entityOffset = 32.0; //size / 2.0;

   GameWorld(playerEntities, entities):super(playerEntities, entities){
     type = 'GameWorld';
     buildWorld();
     generateEnemies(3);  //TODO make more enemies
   }



   Map mapSymbols = {'#': 'BUSH',
      //'@': (double x, double y){return new Bat(x, y);}, //bat for testing, this will be the icon for 'Next Screen'
      'N': null};
   Map<String, List> mapLayout = {'GameWorld': [
      ['#','#','#','#','#','#','#','#','#','#','#','#','#','#','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','N','N','N','N','N','N','N','N','N','N','N','N','N','#'],
      ['#','#','#','#','#','#','#','#','#','#','#','#','#','#','#']]};


   generateEnemies(num numberOfEnemies){
    var x,y, offset = 500;
    for(var i = 0; i < numberOfEnemies; i++){
      x = rng.nextInt(300);
      y = rng.nextInt(300);
      entities.add(new Goblin(x + offset.toDouble(),y + offset.toDouble(), this));
    }
  }

  void updateEntities(num time){
   entities.forEach((BaseEntity entity) => entity.updateAllComponents(time));
  }

   void buildWorld(){
    double x = entityOffset;
    double y = entityOffset;
   mapLayout['GameWorld'].forEach((l){
      l.forEach((s){
        if (mapSymbols[s] != null) {
          var terrain_tile = new Bush(x,y, this);
          entities.add(terrain_tile);
          x += entitySize;
        } else {x += entitySize;}
      });
      x = entityOffset;
      y += entitySize;
    });
  }

   void addEntities(List<Entity> e){
    e.forEach((Entity e){
     entities.add(e);
      stageAddChild(e);
    });
  }


   void removeClient(String id){
     for(var i = 0; i <playerEntities.length; i++){
       Player player =playerEntities[i];
       if(player.ID == id){
         playerEntities.remove(player);
         break;
       }
     }
   }


   Map toJson() {
    var time = {};
    var dateTimeParsed = dateTimeParse.firstMatch(new DateTime.now().toString());
    time = {
        'year'   : dateTimeParsed.group(1),
        'month'   : dateTimeParsed.group(2),
        'day'   : dateTimeParsed.group(3),
        'hour'   : dateTimeParsed.group(4),
        'minute'   : dateTimeParsed.group(5),
        'second'   : dateTimeParsed.group(6),
        'millisecond': dateTimeParsed.group(7)};
    var toReturn =  {
        'type' : type,
        'time' : time,
        'playerEntities' : playerEntities.map((Entity e) => e.toJson()).toList(),
        'entities'  : entities.map((e) => e.toJson()).toList(),
        'entitiesToAdd': entitiesToAdd.map((e) => e.toJson()).toList(),
        'playersToAdd': playersToAdd.map((e) => e.toJson()).toList(),
        'entitiesToRemove': entitiesToRemove.map((e) => e.toJson()).toList(),
        'playersToRemove': playersToRemove.map((e) => e.toJson()).toList()};
    return toReturn;
   }
}