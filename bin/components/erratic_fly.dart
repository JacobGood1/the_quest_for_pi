part of component;

abstract class ErraticFly implements SharedEntity, Movement{
  Random _rng = new Random();

  _updateErraticFly(time){
    erratic_fly();
  }

  void erratic_fly() {
    int x = this._rng.nextInt(4);
    var movements = [moveLeft, moveRight, moveDown, moveUp];
    movements[x]();
  }
}