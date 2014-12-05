library server_component;

import 'dart:math';
import '../entities/entity.dart';
import 'package:the_quest_for_pi/globals.dart';
import '../game_world/game_world.dart' show GameWorld;
import '../game_world/input_manager.dart';

//physics
part 'physics/collision_AABB.dart';
part 'physics/movement.dart';
part 'physics/player_movement.dart';

//flying movements
part 'erratic_fly.dart';

//animation
part 'animation.dart';

//sounds
part 'sound.dart';

//AI
part 'AI/sit_still_run_to_player_if_close.dart';