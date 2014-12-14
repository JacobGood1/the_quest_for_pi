library server_entity;

import 'package:the_quest_for_pi/base_entity.dart';
import 'package:the_quest_for_pi/globals.dart';
import '../game_world/game_world.dart' show GameWorld, CombatGameWorld;
import '../components/component.dart';
import 'package:uuid/uuid.dart';
import '../game_world/input_manager.dart';

//flying creatures
part '../entities/flying_creatures/flying_creature.dart';
part '../entities/flying_creatures/bat.dart';

//player
part 'player.dart';

//terrain
part 'terrain/terrain.dart';
part 'terrain/bush.dart';

//goblins
part 'humanoids/goblins/goblin.dart';

//props
part 'props/combat_star.dart';

Uuid uuid = new Uuid();

class Entity extends BaseEntity {
  CombatGameWorld inWhatInstance;

  Entity(double x, double y) {
    position = new Vector(x,y);
    ID = uuid.v4();
  }

  void addToJson(List<List> attributes){ //place a tuple with a String and a
    additionalJSONInformation.add([attributes[0], attributes[1]]);
  }

  Map toJson(){  //TODO check to see if this works later on, might be buggy
    var additionToReturn = additionalJSONInformation.map((List vals) => {vals[0]: vals[1]}).toList();
    var toReturn =
    {
        'ID': this.ID,
        'positionX': this.position.x,
        'positionY': this.position.y,
        'type': this.type,
        'currentAnimationState': this.currentAnimationState,
        'currentAnimationFrame': this.currentAnimationFrame,
        'currentSoundState': this.currentSoundState,
        'isDead': this.isDead,
        'inCombat': this.inCombat
    };

    additionToReturn.forEach((Map map) => toReturn.addAll(map));
    return toReturn;
  }

  @override
  String toString(){
    return"""
    ID: ${this.ID},
    positionX: ${this.position.x},
    positionY: ${this.position.y},
    type: ${this.type},
    isDead: ${this.isDead},
    inCombat: ${this.inCombat}""";
  }
}


