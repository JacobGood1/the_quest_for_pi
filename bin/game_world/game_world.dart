library server_game_world;

import '../entities/entity.dart';
import 'package:the_quest_for_pi/base_entity.dart';
import 'dart:math';
import 'package:the_quest_for_pi/globals.dart' show Vector;

part 'combat_world.dart';

//this will find the exact date of a DateTime.now() string by parsing out all the numbers
final RegExp dateTimeParse = new RegExp(r'([0-9]{4})\-([0-9]{2})\-([0-9]{2}) ([0-9]+)\:([0-9]+)\:([0-9]+)\.([0-9]*)');
final Random rng = new Random();


abstract class GameWorldContainer{
  String ID;
  List<Player> playerEntities;
  List<Entity> entities;

  GameWorldContainer(this.playerEntities, this.entities){
    this.ID = uuid.v4();
  }

  Map toJson();
}


class GameWorld extends GameWorldContainer{
   var entitySize = 64.0;
   var entityOffset = 32.0; //size / 2.0;

   GameWorld(playerEntities, entities):super(playerEntities, entities){
     buildWorld();
     generateEnemies(3);  //TODO make more enemies
   }



   Map mapSymbols = {'#': (double x, double y){return new Bush(x, y);},
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
    var x,y, offset = 200;
    for(var i = 0; i < numberOfEnemies; i++){
      x = rng.nextInt(600);
      y = rng.nextInt(600);
      entities.add(new Goblin(x + offset.toDouble(),y + offset.toDouble()));
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
          var terrain_tile = mapSymbols[s](x, y);
          addEntity(terrain_tile);
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

   void addPlayer(Entity e){
   playerEntities.add(e);
    stageAddChild(e);
  }

   void removePlayer(String id){
    for(var i = 0; i <playerEntities.length; i++){
      Player player =playerEntities[i];
      if(player.ID == id){
       playerEntities.remove(player);
        break;
      }
    }
  }

   void addEntity(Entity e){
   entities.add(e);
    stageAddChild(e);
  }

   void stageAddChild(e){}

   Map toJson() {
    var time = {};
    var dateTimeParsed = dateTimeParse.firstMatch(new DateTime.now().toString());
    time = {'year'   : dateTimeParsed.group(1),
           'month'   : dateTimeParsed.group(2),
             'day'   : dateTimeParsed.group(3),
            'hour'   : dateTimeParsed.group(4),
          'minute'   : dateTimeParsed.group(5),
          'second'   : dateTimeParsed.group(6),
        'millisecond': dateTimeParsed.group(7)};
    return {'time' : time,
            'playerEntities' : playerEntities.map((Entity e) => e.toJson()).toList(),
            'entities'  : entities.map((e) => e.toJson()).toList()};
  }
}