library server_entity;

import 'package:http/http.dart' as http;
import 'package:the_quest_for_pi/base_entity.dart';
import 'package:the_quest_for_pi/globals.dart';
import '../game_world/game_world.dart';
import '../components/component.dart';
import 'package:uuid/uuid.dart';

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

//weapons
part 'weapons/goblin_spear.dart';

Uuid uuid = new Uuid();

class Entity extends BaseEntity {
  Entity(double x, double y) {
    position = new Vector(x,y);
    ID = uuid.v4();
  }

  void addToJson(List<List> attributes){ //place a tuple with a String and a
    additionalJSONInformation.add([attributes[0], attributes[1]]);
  }

  Map toJson(){
    return
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


