library component;

import 'dart:convert';

import '../main.dart';
import 'package:the_quest_for_pi_production/components/shared_component.dart';

part 'input_manager.dart';
part 'player_movement.dart';

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

