import ddf.minim.*;

Minim minim;
AudioSample kick;
AudioSample snare;
AudioSample selection;
AudioSample correct;
AudioSample start;
AudioSample pingPong;
AudioSample fail;
AudioSample gameOver;
AudioPlayer backgroundMusic;

final int stateGameMenuScreenDisplay = 0;
final int stateInstructions = 1;
final int statePingPongGame = 2;

int stateOfGame = stateGameMenuScreenDisplay;

void setup(){
  size(1280, 720);
  setup_GameMenu();
  setup_GameInstructions();
  setup_PingPongGame();  
  setup_TUIO();
  cursor(ARROW);
  
  // Load all audio files
  minim = new Minim(this);
  kick = minim.loadSample( "BD.mp3", // filename
                            512      // buffer size
                         );
                         // if a file doesn't exist, loadSample will return null
  if ( kick == null ) println("Didn't get kick!");
  
  // load SD.wav from the data folder
  snare = minim.loadSample("SD.wav", 512);
  if ( snare == null ) println("Didn't get snare!");
  
  selection = minim.loadSample("game-selection.wav", 512);
  if ( selection == null ) println("Didn't get selection!");
  
  correct = minim.loadSample("game-correct-selection.wav", 512);
  if ( correct == null ) println("Didn't get correct!");
  
  start = minim.loadSample("game-start.wav", 512);
  if ( start == null ) println("Didn't get start!");
  
  pingPong = minim.loadSample("game-ping-pong.wav", 512);
  if ( pingPong == null ) println("Didn't get pingPong!");
  
  fail = minim.loadSample("game-fail-3.wav", 512);
  if ( fail == null ) println("Didn't get fail!");
  
  gameOver = minim.loadSample("game-over-2.wav", 512);
  if ( gameOver == null ) println("Didn't get gameOver!");
  
  backgroundMusic = minim.loadFile("game-background.mp3", 512);
  if ( backgroundMusic == null ) println("Didn't get backgroundMusic!");
}

void draw(){
  backgroundMusic.play();
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