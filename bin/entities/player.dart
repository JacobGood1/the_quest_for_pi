part of server_entity;

RegExp findSolutionInteger = new RegExp(r'mode\=display\"\>(-?[0-9]+)\<\/script\>'),
       findSolutionRatio = new RegExp(r'data\-output\-repr\=\"(-?[0-9]+\/[0-9]+)\"');

class Player extends Entity with PlayerMovement, Movement, Collision_AABB, WalkingAnimation, FootStep, HealthBar, Combat{

  String currentProblem, problemSolutionAttempt, problemSolution;
  Entity attackTarget;
  String currentKey = '';
  List<String> currentActiveKeys = [];
  Map _keyDecipher = new Map.fromIterables(new List.generate(26, (int index) => index + 65), "abcdefghijklmnopqrstuvwxyz".split(""));
  Map<String,bool> keysPressed = {'d': false, 'w': false, 'a': false, 's': false};
  bool problemSolved = true;
  int spellReserve = 0;
  Player(x, y, GameWorldContainer inWhatInstance):super(x,y) {
    this.inWhatInstance = inWhatInstance;
    componentInitFunctionList.addAll([initCollisionAABB, initWalkingAnimation, initHealthBar, initCombat]);
    initAllComponents();
    componentUpdateFunctionList.addAll([updateMovement, updatePlayerMovement,updateCollisionAABB, updateInputProcessor, updateWalkingAnimation, updateFootStep]);
    componentCombatModeFunctionList.add(_updateGenProblem);
    movementSpeed = 300.0;
    type = 'Player';
    if(problemSolved){
      generateRandomProblemAndAnswer();
      problemSolved = false;
    }
  }

  _updateGenProblem(num time){ //NOW once the client solves the problem come back here and update this crap
    //print('currentProblem: ' + currentProblem + ' solution: ' + '${problemSolution}');
    if(problemSolved){
      generateRandomProblemAndAnswer();
      problemSolved = false;
    } else{
      if(problemSolution != null && problemSolutionAttempt != null){
        if(_doAnswersMatch(problemSolution, problemSolutionAttempt)){
          problemSolved = true;
          spellReserve++;
          problemSolution = null;
          problemSolutionAttempt = null;
        }
      }
    }
  }

  void castFireBall(){  //TODO cast a fireball toward an entity
    inWhatInstance.addEntity(new FireBall(position.x,position.y,inWhatInstance, attackTarget));
  }

  bool _doAnswersMatch(String doesThis, String matchThis){
    var whiteStrip1 = doesThis.split(' ').where((e) => e != '').fold('', (e, s) => e + s),
        whiteStrip2 = matchThis.split(' ').where((e) => e != '').fold('', (e, s) => e + s);
    return whiteStrip1 == whiteStrip2;
  }
  updateInputProcessor(double dt){
    if(isAnyKeyDown()){
      currentKey = currentActiveKeys.last;
    }
    else{
      currentKey = '';
    }
  }
  bool isKeyBeingPressed(String key){
    if(currentActiveKeys.isNotEmpty){
      return currentActiveKeys.contains(key);
    }
    return false;
  }
  bool isTheLastKeyHeld(String key){
    return currentKey == key;
  }

  bool areAnyOfTheseKeysActive(List<String> keys){
    for(var key in keys){
      if(currentActiveKeys.contains(key)){
        return true;
      }
    }
    return false;
  }

  bool isAnyKeyDown(){
    return currentActiveKeys.isNotEmpty;
  }

  //crappy code that gets the job done for demonstration sake
  /*void generateRandomProblemAndAnswer(){
    String equationToReturn = '';
    List<String> ops = '*+-'.split(''); //TODO add division back in
    Function randomOps = () => ops[rng.nextInt(ops.length)];
    int r1 = rng.nextInt(9) + 1, r2 = rng.nextInt(9) + 1, r3 = rng.nextInt(9) + 1;
    String ro1 = randomOps(), ro2 = randomOps();

    currentProblem = '${r1} ${ro1} ${r2} = x';


    problemSolution = [r1,r2].reduce((val,element) {
      if(ro1 == '/'){
        return val / element;
      } else if(ro1 == '*'){
        return val * element;
      } else if(ro1 == '+'){
        return val + element;
      } else if(ro1 == '-'){
        return val - element;
      }
    }).toString();


  }*/

  generateRandomProblemAndAnswer(){
    currentProblem = generateRandomProblem();
    solveProblem(currentProblem);
  }

  generateRandomProblem(){
    String equationToReturn = '';
    List<String> ops = '*/+-'.split('');
    Function randomOps = () => ops[rng.nextInt(ops.length)];
    var randop = randomOps();
    Function randomNum = () => (rng.nextInt(8) + 1).toString();
    String typeOfEquation = randomOps();

    var nums = new List.generate(3,(i) => i);
    for(int i = 0; i < nums.length; i++){
      var num = rng.nextInt(9) + 1;
      while(nums.contains(num)){
        num = rng.nextInt(9) + 1;
      }
      nums[i] = num;
    }

    equationToReturn = equationToReturn +
    '${nums[0]} ${randomOps()} ${nums[1]} = ${nums[2]}';

    var insertionPoint =
    equationToReturn
    .split(' ')
    .where((e)=> !'+-/=*'.contains(e))
    .toList()[rng.nextInt(3)];

    var format = equationToReturn
    .split(' ')
    .map((e) {
      if(e == insertionPoint){
        if(typeOfEquation == '*'){
          return '${e}x';
        } else if(typeOfEquation == '+'){
          return '${e} + x';
        } else if(typeOfEquation == '-'){
          return '${e} - x';
        } else{
          return '${e}\/x';
        }
        return e + 'x';
      } else{
        return e;
      }
    })
    .toList();


    equationToReturn = format.reduce((start, elm) => '${start} ${elm}');

    return equationToReturn;
  }


  void solveProblem(String equation){

    String leftSide = equation.split(' ').takeWhile((c) => c != '=').reduce((start, ele) => start + ele);
    String rightSide = equation.split(' ').skipWhile((c) => c != '=').skip(1).reduce((start, ele) => start + ele);
    String url = new Uri.http('www.sympygamma.com', '/input/', {'i' : 'solve(Eq(${leftSide},${rightSide}),x)'}).toString();

    http.get(url).then((response) {
      try {
        problemSolution = findSolutionInteger.allMatches(response.body).toList()[0][1];
      } catch(e) {
        problemSolution = findSolutionRatio.allMatches(response.body).toList()[0][1];
      }
    });
  }



  Map toJson(){
    return
    {
        'ID': this.ID,
        'positionX': this.position.x,
        'positionY': this.position.y,
        'type': this.type,
        'currentAnimationState': this.currentAnimationState,
        'currentAnimationFrame': this.currentAnimationFrame,
        'currentSoundState': this.currentSoundState,
        'isDead': this.isDead,
        'inCombat': this.inCombat,
        'health' : this.health,
        'currentProblem' : this.currentProblem,
        'problemSolution' : this.problemSolutionAttempt,
        'spellReserve' : this.spellReserve
    };
  }
}