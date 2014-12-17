part of game_world_client;



bool firstTimeCombatWorld = true;

//TODO make the server generate the problems, for now the client will generate them



class CombatGameWorld extends GameWorldContainer{
  static Bitmap backGround;
  var currentDisplayedProblem = new TextField();
  SimpleButton fireBallButton;
  Shape rectBox = new Shape();
  math.Point stageMouse = new math.Point(0.0,0.0);
  bool selectionMade = false, fireBallButtonPressed = false;
  String entityToAttack, currentProblem, displayManaAmount;
  CombatGameWorld(Map messageData){


    CombatGameWorld.backGround = new Bitmap(resourceManager.getBitmapData('backGroundCombat'))
      ..scaleX = 2
      ..scaleY = 2;
    canvas.width = backGround.width.toInt();
    canvas.height = backGround.height.toInt();
    stage.addChild(backGround);
    isGameWorldReady = true;

    Sprite hotbar = new Sprite()
      ..addChild(new Bitmap(resourceManager.getBitmapData('spell_hotbar')))
      ..x = stage.width / 2 - 200
      ..y = 900;

    fireBallButton = new SimpleButton(
        new Bitmap(resourceManager.getBitmapData('UI_fireball_upstate')),
        new Bitmap(resourceManager.getBitmapData('UI_fireball_downstate')),
        new Bitmap(resourceManager.getBitmapData('UI_fireball')),
        new Bitmap(resourceManager.getBitmapData('UI_fireball_downstate'))); //TODO tweak the x and y more fireball is suckage for now


    hotbar.addChild(fireBallButton..x += 25..y += 25);

    stage.addChild(hotbar);
    stage.addChild(rectBox);

    stage.onMouseClick.listen((MouseEvent e) => stageMouse = new math.Point(e.stageX, e.stageY));




    currentDisplayedProblem
      ..defaultTextFormat = new TextFormat('Spicy Rice', 30, Color.White)
      ..x = 400
      ..y = 400
      ..width = 1000
      ..height = 50
      ..wordWrap = true;
    stage.addChild(currentDisplayedProblem..filters = [new GlowFilter(Color.Yellow, 0, 0)]);

    stage.addChild( //TODO add mana tracker to stage get it displaying properly
        new TextField()
          ..defaultTextFormat = new TextFormat('Spicy Rice', 30, Color.White)
          ..x = 100
          ..y = 100
          ..width = 500
          ..height = 50
          ..wordWrap = true
    );


    html.InputElement inputFromUser = (html.querySelector("#htmlObject") as html.InputElement);

    var htmlObject = new HtmlObject(inputFromUser)
      ..x = 323
      ..y = 430;
    stage.addChild(htmlObject);

    new InputManager.combatWorld(inputFromUser);


  }

  String getCurrentProblemFromServer(){
    for(Player player in playerEntities){
      if(player.ID == main.ID){
        return player.currentProblem;
      }
    }
  }


  math.Point mouse = new math.Point(0.0,0.0);
  void updateEntities(List<Map>serverEntities, List<Map>serverPlayers, num dt){
    if(getCurrentProblemFromServer() != null){
      currentDisplayedProblem.text = getCurrentProblemFromServer();
    }
    mouse = new math.Point(stage.mouseX, stage.mouseY);
    var entityLocations = {}, allHitBoxLocations = [];

    for(var i = 0; i < serverEntities.length; i++){
      var se = serverEntities[i];
      for(Entity entity in entities){
        if(entity.ID == se['ID']){
          entity.extractData(se); //this will mutate the clients to reflect the server objects
          if(entity.isDead){
            //died       //TODO play death animation
            break;
          }
          entity.updateAllCombatModeComponents(dt);
          entityLocations[entity.ID] = entity.position;
          break;
        }
      }
    }

    for(var i = 0; i < serverPlayers.length; i++){
      var pe = serverPlayers[i];
      for(Player player in playerEntities){
        if(player.ID == pe['ID']){
          player.extractData(pe); //this will mutate the clients to reflect the server objects
          if(player.ID == ID && player.isDead){
            InputManager.stillWorking = false;
            //died       //TODO play death animation
            break;
          }
          player.updateAllCombatModeComponents(dt);
          String hasMana = player.calcCurrentMana();
          if(hasMana != null){
            displayManaAmount = hasMana;
          }
          entityLocations[player.ID] = player.position;
          break;
        }
      }
    }
    if(!selectionMade){
      entityLocations.forEach((k,v) {
        var hitbox = new Rectangle(v.x,v.y + 170,45,80);
        if(hitbox.containsPoint(mouse)){
          if(hitbox.containsPoint(stageMouse)){
            rectBox.graphics..clear()..rect(v.x + 10,v.y,45,45)..fillColor(Color.Red);
            entityToAttack = k;
          }
        }
      });
    }


  }

  void positionEntities(num time){
    //Vector positionOffSet = new Vector()
    playerEntities.forEach((Player player) {

      player.updateAllCombatModeComponents(time);
    });
    entities.forEach((entity) => entity.updateAllCombatModeComponents(time));
  }
  void removePlayer(String id){
    for(var i = 0; i < playerEntities.length; i++){
      Player player = playerEntities[i];
      if(player.ID == id){
        playerEntities.remove(player);
        stage.removeChild(player);
        break;
      }
    }
  }
  void clearEntities(){
    if(stage.numChildren != 0){
      stage.removeChildren(0,stage.numChildren - 1);
    }
    entities.clear();
    playerEntities.clear();
  }

  void addEntities(List<Entity> e){
    e.forEach((Entity e){
      entities.add(e);
      stage.addChild(e);
    });
  }

  void addEntity(Entity e){

    entities.add(e);
    stage.addChild(e);
  }
  void addPlayerEntity(Entity e){
    playerEntities.add(e);
    stage.addChild(e);
  }

  Map toJson() {
    return {
        'playerEntities' : playerEntities.map((e) => e.toJson).toList(),
        'entities'  : entities.map((e) => e.toJson).toList()};
  }
}