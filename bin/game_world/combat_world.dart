part of server_game_world;


//server adds a gameworld to itself and loops over it with updates,
class CombatGameWorld{
  List<Player> playerEntities = [];
  List<Entity> enemyEntities = [];

  CombatGameWorld(this.playerEntities, this.enemyEntities){
    playerEntities.forEach((Player player) => player..position = new Vector(canvasWidth.toDouble(),canvasHeight.toDouble()));
    enemyEntities.forEach((Entity entity) => entity..position = new Vector(canvasWidth.toDouble(),canvasHeight.toDouble()));

  }
}