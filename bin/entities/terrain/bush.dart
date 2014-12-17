part of server_entity;

class Bush extends Terrain {
  Bush(double x, double y, GameWorldContainer inWhichInstance) : super (x,y, inWhichInstance){
    type = 'Bush';
  }
}