final int stateGameMenuScreenDisplay = 0;
final int stateInstructions = 1;
final int statePingPongGame = 2;

int stateOfGame = stateGameMenuScreenDisplay;

void setup(){
  size(400, 400);
  setup_GameMenu();
  setup_GameInstructions();
  setup_PingPongGame();  
  setup_TUIO();
  cursor(ARROW);
}

void draw(){
  switch(stateOfGame){
    case stateGameMenuScreenDisplay:
      // print("Game Menu");
      draw_GameMenu();
      break;
    case stateInstructions:
      //print("Instructions");
      draw_GameInstructions();
      break;
    case statePingPongGame:
      // print("Ping Pong");
      draw_PingPongGame();
      break;
    default:
      print("Not a valid state");
      break;
  }
}