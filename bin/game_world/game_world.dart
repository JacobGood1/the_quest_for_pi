library server_game_world;

import '../entities/entity.dart';
import 'dart:mirrors'; //DELETE
import '../globals.dart' as g;
import 'dart:convert';  //TODO delete this test code when done

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
    //GameWorld.addEntity(new Bat(50.0,50.0));
    //GameWorld.addEntity(new Player(50.0,50.0));  //DELETE
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

  static void addEntity(Entity e){
    GameWorld.entityManager.add(e);
    stageAddChild(e);
  }

  static void stageAddChild(e){}

  static Map toJson() {
    return {'playerEntities' : playerEntities.map((Entity e) => e.toJson()).toList(),
            'entityManager'  : GameWorld.entityManager.map((e) => e.toJson()).toList(),
            'assets': assets};
  }
}