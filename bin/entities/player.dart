part of server_entity;

class Player extends Entity with PlayerMovement, Movement, Collision_AABB, WalkingAnimation, FootStep, HealthBar, Combat{

  String currentProblem, problemSolutionAttempt, problemSolution;
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
    if(problemSolved){
      generateRandomProblemAndAnswer();
      problemSolved = false;
      problemSolutionAttempt = null;
    }
    if(problemSolution != null && problemSolutionAttempt != null){
      if(_doAnswersMatch(problemSolution, problemSolutionAttempt)){
        print('you solved it!');
        problemSolved = true;
        spellReserve++;
        print(spellReserve);
      }
    }
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
  void generateRandomProblemAndAnswer(){
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


  }


  //this code was telling wolfram alpha to solve the problem, i had to majorly downgrade the system
  static var randomNum = ( )=> 1;
  var comment = '''
  RegExp findSolution = new RegExp(r'\"mOutput\"\: \"\{\{x == (-?[0-9]*[\/]?[0-9]+)');
  solveProblem(String currentProblem){
    Uri u = new Uri.http('wolframalpha.com', '/input/', {'i' : currentProblem});
    var url = u.toString();
    http.get(url).then((response) {
      while(problemSolution == null){
        problemSolution = findSolution.allMatches(response.body).toList()[0][1];
      }
    });
  }

  String generateRandomProblem(){
    String equationToReturn = '';
    List<String> ops = '*/+-'.split('');
    Function randomOps = () => ops[rng.nextInt(ops.length)];
    var randop = randomOps();
    Function randomNum = () => (rng.nextInt(100) + 1).toString();
    int equationLengthMin = rng.nextInt(2) + 1;
    int equationLengthMax = rng.nextInt(2) + equationLengthMin + 1;
    String typeOfEquation = randomOps();
    int insertionPoint = rng.nextInt(equationLengthMax);
    while(insertionPoint < equationLengthMin){
      insertionPoint = rng.nextInt(equationLengthMax);
    }

    for(var i = equationLengthMin; i < equationLengthMax; i++){

      if(i == insertionPoint){
        if(typeOfEquation == '*'){
          equationToReturn = equationToReturn + ' ${randomNum()}x ' + randomOps();
        }
        else if(typeOfEquation == '+'){
          equationToReturn = equationToReturn + ' ${randomNum()} + x ' + randomOps();
        }
        else if(typeOfEquation == '-'){
            equationToReturn = equationToReturn + ' ${randomNum()} - x ' + randomOps();
          }
          else if(typeOfEquation == '/'){
              equationToReturn = equationToReturn + ' ${randomNum()}\/x ' + randomOps();
            }

      } else{
        equationToReturn = equationToReturn + ' ' + randomNum() + ' ' + randomOps();
      }

    }
    equationToReturn = equationToReturn + ' ' + randomNum();
    equationToReturn = equationToReturn + ' = ${randomNum()}';

    return equationToReturn;
  }
''';

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