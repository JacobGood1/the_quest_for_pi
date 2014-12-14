library client_component;

import 'dart:math';
import '../entities/entity.dart';
import 'package:the_quest_for_pi/globals.dart' as g;
import '../game_world/input_manager.dart';
import '../main.dart' as main show ID, currentGameWorld;
import '../game_world/game_world_container.dart' show GameWorld, stage, resourceManager;
import 'package:stagexl/stagexl.dart';

//physics
part 'physics/collision_AABB.dart';
part 'physics/movement.dart';
part 'player_movement.dart';

//flying
part 'erratic_fly.dart';

//animation
part 'animation.dart';

//sound
part 'sound.dart';

//combat
part 'combat/combat.dart';
part 'combat/health_bar.dart';