PImage img1;
PImage imgTitle;
int marksCounterMenu = 0;

Square square0;

void setup_GameMenu(){
  img1 = loadImage("ping-pong-face.png");
  imgTitle = loadImage("title.png");
  int squareSize = 100;
  square0 = new Square(0, width / 2, height / 2 + squareSize, 30, squareSize);
}

void draw_GameMenu(){
  background(17, 69, 63);
  
  image(img1, width - img1.width, height - img1.height);
  image(imgTitle, 0, 0);
  
  drawSquare(square0);
  
  detectFiducialMarkMenu();
  
  // If the two players have been saved, pass to the game
  if(marksCounterMenu == 1){
    stateOfGame = stateInstructions;
  }
}

void saveFiducialMark(TuioObject tobj){  
  fill(255, 255, 255);
  int markPosX = tobj.getScreenX(width);
  int markPosY = tobj.getScreenY(height);
  
  if(marksCounterMenu != 1){
    //println("Quedan marcas por centrar");
    if(markPosX > square0.xpos + square0.margin && markPosX < square0.xpos + square0.squareWidth - square0.margin && markPosY > square0.ypos + square0.margin && markPosY < square0.ypos + square0.squareWidth - square0.margin){
      //println("Marca fiducial" + tobj.getSymbolID() + " centrada");
      marksCounterMenu++;
      kick.trigger();
    }
  }
  else{
    print("NO quedan marcas por centrar");
    
  }
}

void detectFiducialMarkMenu(){
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
    for (int i=0;i<tuioObjectList.size();i++) {
       TuioObject tobj = tuioObjectList.get(i);
       //println("Object position in screen: " + tobj.getScreenX(width) + ", " + tobj.getScreenY(height));
       //println("Paddle position in screen: " + paddleYPos);
       stroke(0);
       fill(0);
       // Operate the origin of the coordinate system
       pushMatrix();
       // Translate it to the center of the object
       translate(tobj.getScreenX(width),tobj.getScreenY(height));
       // Rotate it the received (throgh the camera) angle
       rotate(tobj.getAngle());
       popMatrix();
       fill(255, 0, 0);
       // Move the ellipse along the TUIO Object
       ellipse(tobj.getScreenX(width), tobj.getScreenY(height), 30, 30);
       pushStyle();
       fill(0,0,255);
       textSize(30);
       text(tobj.getSymbolID() + "  " + tobj.getScreenY(height), tobj.getScreenX(width), tobj.getScreenY(height));  // Object identifier
       popStyle();
       // Map the position camera screen -> game screen
       int gameYPos1 = (int)map(tobj.getScreenY(height), 60, height-60, 0, height);
       constrain(gameYPos1, 0, height);
       movePaddle1(gameYPos1);
       saveFiducialMark(tobj);
    }
}