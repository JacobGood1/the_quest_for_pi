part of shared_component;

class Vector{
  double x,y;

  Point head, tail;

  Vector(this.x, this.y, [Vector start]){
    if(start != null){
      head = new Point(start.x, start.y);
      tail = new Point(head.x + x, head.y + y);
    }
  }

  operator +(Vector other) => new Vector(x + other.x, y + other.y);
  operator -(Vector other) => new Vector(x - other.x, y - other.y);
  operator *(Vector other) => new Vector(x * other.x, y * other.y);
  operator /(Vector other) => new Vector(x / other.x, y / other.y);

  Vector copy(){
    return new Vector(this.x, this.y);
  }

  Vector scale(num scalar){
    return new Vector(x * scalar, y * scalar);
  }
  void zero(){
    x = 0.0;
    y = 0.0;
  }
  Vector negate(){
    return new Vector(x * -1, y * -1);
  }

  toString(){
    return "[x:$x y:$y]";
  }
}

num abs(num n){
  if(n.isNegative){
    return n * -1;
  }
  return n;
}


num degreesToRadians(num degrees){
  return degrees * PI / 180;
}