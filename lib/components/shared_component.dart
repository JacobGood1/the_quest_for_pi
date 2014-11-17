library shared_component;

import 'dart:math';
import '../globals.dart';

part 'physics/vector.dart';
part 'physics/movement.dart';


abstract class SharedComponentData{
  Vector position,
         velocity;

  double movementSpeed;
  void moveUp();
  void moveLeft();
  void moveDown();
  void moveRight();
}