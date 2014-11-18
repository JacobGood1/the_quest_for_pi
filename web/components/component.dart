library component;

import 'dart:math';

import '../main.dart';
import 'package:the_quest_for_pi/components/shared_component.dart';

part 'input_manager.dart';
part 'player_movement.dart';
part 'erratic_fly.dart';

double _stageBoundX = canvas.width.toDouble(),
       _stageBoundY = canvas.height.toDouble();

//var ws = webSocket;

abstract class ComponentData extends SharedComponentData{

}

abstract class PlayerComponentData extends ComponentData{
       bool isKeyBeingPressed(String key);
       bool areAnyOfTheseKeysActive(List<String> keys);
       bool isAnyKeyDown();
}

