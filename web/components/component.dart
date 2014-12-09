library client_component;

import 'dart:math';
import '../entities/entity.dart';
import 'package:the_quest_for_pi/globals.dart';
import '../game_world/input_manager.dart';
import '../game_world/game_world.dart'show GameWorld, stage;
import 'package:stagexl/stagexl.dart';
import 'dart:async';

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