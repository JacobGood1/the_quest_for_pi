part of client_entity;

class CombatStar extends Entity{
  CombatStar(ID, posX,posY):super('CombatStar', posX, posY, ID){
    main.currentGameWorld.addEntity(this);
    pivotX = width / 2;
    pivotY = height / 2;
    scaleX = 1/10;
    scaleY = 1/10;
    componentUpdateFunctionList.add((time){
      rotation += 1 * time;
    });
  }
}