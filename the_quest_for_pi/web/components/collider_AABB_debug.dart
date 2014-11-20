part of component;

abstract class ColliderAABBDebugData {
  Rectangle collider;
}

abstract class ColliderAABBDebug implements ColliderAABBDebugData{
  Shape colliderDebug = new Shape();

  _initASDAS(){
    //
  }

  _updateColliderAABBDebug(time) {
    colliderDebug.graphics .. clear()
      ..strokeColor(Color.Black, 5.0)
      ..rect(collider.topLeft.x, collider.topLeft.y, collider.width, collider.height);
  }
}