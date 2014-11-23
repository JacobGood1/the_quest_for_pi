library component;

import 'dart:math';
import 'package:stagexl/stagexl.dart' show Shape, Color;
import '../main.dart';
import 'package:the_quest_for_pi/components/shared_component.dart';
import '../entities/entity.dart';

part 'collider_AABB_debug.dart';
part 'input_manager.dart';
part 'player_movement.dart';
part 'erratic_fly.dart';

double _stageBoundX = canvas.width.toDouble(),
       _stageBoundY = canvas.height.toDouble();

//var ws = webSocket;

abstract class ComponentData implements Entity{
}

/*
abstract class PlayerComponentData implements ComponentData{
       bool isKeyBeingPressed(String key);
       bool areAnyOfTheseKeysActive(List<String> keys);
       bool isAnyKeyDown();
}

*/