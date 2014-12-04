library server_entity;

import 'package:the_quest_for_pi/base_entity.dart';
import 'package:the_quest_for_pi/globals.dart';
import '../game_world/game_world.dart' show GameWorld;
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


Uuid uuid = new Uuid();

abstract class Entity extends BaseEntity {
  Entity(double x, double y) {
    position = new Vector(x,y);
    ID = uuid.v4();
  }
  get entityManager => GameWorld.entityManager;
}


