library server_game_world;

import '../entities/entity.dart';
import 'package:the_quest_for_pi/base_entity.dart';

//this will find the exact date of a DateTime.now() string by parsing out all the numbers
final RegExp dateTimeParse = new RegExp(r'([0-9]{4})\-([0-9]{2})\-([0-9]{2}) ([0-9]+)\:([0-9]+)\:([0-9]+)\.([0-9]*)');

class GameWorld{
  static var entitySize = 64.0;
  static var entityOffset = 32.0; //size / 2.0;
  static List playerEntities = [];

  static List<BaseEntity> entityManager = [];

  static List<List> assets = //add new assets here!
  //class   //assetName
  [['Bush','bush'],  //TODO possibly make objects add their own asset?
   ['Bat','bat'],
   ['Player', 'black_mage']]
    .map((list) => [list[0],'assets/images/${list[1]}.png']).toList();

  static Map mapSymbols = {'#': (double x, double y){return new Bush(x, y);},
      //'@': (double x, double y){return new Bat(x, y);}, //bat for testing, this will be the icon for 'Next Screen'
      'N': null};
  static Map<String, List> mapLayout = {'GameWorld': [
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

  static initWorld(){
    buildWorld();
  }


  void updateEntities(num time){
    GameWorld.entityManager.forEach((BaseEntity entity) => entity.updateAllComponents(time));
  }

  static void buildWorld(){
    double x = entityOffset;
    double y = entityOffset;
    GameWorld.mapLayout['GameWorld'].forEach((l){
      l.forEach((s){
        if (GameWorld.mapSymbols[s] != null) {
          var terrain_tile = mapSymbols[s](x, y);
          addEntity(terrain_tile);
          x += entitySize;
        } else {x += entitySize;}
      });
      x = entityOffset;
      y += entitySize;
    });
  }

  static void addEntities(List<Entity> e){
    e.forEach((Entity e){
      GameWorld.entityManager.add(e);
      stageAddChild(e);
    });
  }

  static void addPlayer(Entity e){
    GameWorld.playerEntities.add(e);
    stageAddChild(e);
  }

  static void removePlayer(String id){
    for(var i = 0; i < GameWorld.playerEntities.length; i++){
      Player player = GameWorld.playerEntities[i];
      if(player.ID == id){
        GameWorld.playerEntities.remove(player);
        break;
      }
    }
  }

  static void addEntity(Entity e){
    GameWorld.entityManager.add(e);
    stageAddChild(e);
  }

  static void stageAddChild(e){}

  static Map toJson() {
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
            'entityManager'  : GameWorld.entityManager.map((e) => e.toJson()).toList(),
            'assets': assets};
  }
}