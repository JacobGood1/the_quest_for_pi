library client_component;

import 'dart:math';
import '../entities/entity.dart';
import '../game_world/input_manager.dart';
import '../main.dart' as main show ID, currentGameWorld;
import 'package:stagexl/stagexl.dart';

//physics
part 'physics/collision_AABB.dart';
part 'physics/movement.dart';
part 'player_movement.dart';

//flying
part 'erratic_fly.dart';

//animation
part 'animation/walking.dart';
part 'animation/combat.dart';

//sound
part 'sound.dart';

//combat
part 'combat/combat.dart';
part 'combat/health_bar.dart';