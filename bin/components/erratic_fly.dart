part of server_component;

abstract class ErraticFly implements Entity, Movement{
  Random _rng = new Random();

  void updateErraticFly(num time) {
    int x = this._rng.nextInt(4);
    var movements = [moveLeft, moveRight, moveDown, moveUp];
    movements[x]();
  }
}