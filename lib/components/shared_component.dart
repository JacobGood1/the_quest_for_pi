library shared_component;

import 'dart:math';
import '../globals.dart';
import '../entities/shared_entity.dart';

part 'physics/vector.dart';
part 'physics/movement.dart';
part 'physics/collision_AABB.dart';

/*
abstract class SharedComponentData{
  static List<SharedEntity> entityManager;
  Vector position,
         velocity;
  double movementSpeed,
        lastPosition_x,
        lastPosition_y,
        size;
  Rectangle collider;
  bool isColliding;
  Set collidingWith;

  //abstract class SharedMovementData{
  double movementSpeed;
  void moveUp();
  void moveLeft();
  void moveDown();
  void moveRight();

  checkCollision();
  //}

}
*/