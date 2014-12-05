part of client_entity;

class Goblin extends Entity with Movement, Collision_AABB{
  Goblin(String ID, x, y, int animeFrame, String animeState, String soundState):super('Goblin',x,y, ID) {
    componentInitFunctionList.addAll([initCollisionAABB]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement,updateCollisionAABB]);
    movementSpeed = 100.0;
    currentAnimationFrame = animeFrame;
    currentAnimationState = animeState;
    currentSoundState = soundState;
  }
}