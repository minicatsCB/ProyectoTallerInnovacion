int circleX, circleY;  // Position of circle button
int circleSize = 90;  // Diameter of circle
color circleColor, circleHighlight, currentColor;  // Circle aesthetics
boolean circleOver;  // Is the mouse over the button?

PImage img1;
PImage imgTitle;

void setup_GameMenu(){
  img1 = loadImage("ping-pong-face.png");
  imgTitle = loadImage("title.png");
  circleColor = color(150);
  circleHighlight = color(200);
  circleX = width / 2;
  circleY = height / 2;
}

void draw_GameMenu(){
  update();
  background(17, 69, 63);
  
  // If the mouse is over circle, change its color
  if(circleOver){
    fill(circleHighlight);
  }
  else{
    fill(circleColor);
  }
  
  stroke(0);
  ellipse(circleX, circleY, circleSize, circleSize);
  
  fill(0, 255, 0);
  textSize(10);
  text("Start", circleX, circleY);
  
  image(img1, width - img1.width, height - img1.height);
  image(imgTitle, 0, 0);
}

/*
  Check if the mouse is inside the circle
  We could merge this method with overCircle,
  but just in case in the future we want add
  extra buttons
*/
void update(){
  if(overCircle(circleX, circleY, circleSize)){
    circleOver = true;
  }
  else{
    circleOver = false;
  }
}

/*
  Check if the mouse is inside the circle
  If so, return true, otherwise, return false
*/
boolean overCircle(int x, int y, int diameter){
  float distX = x - mouseX;
  float distY = y - mouseY;
  if(sqrt(sq(distX) + sq(distY)) < diameter / 2){
    return true;
  }
  else{
    return false;
  }
}

/*
  Check wether the button has been pressed or not
*/
void mousePressed(){
  if(circleOver){
    circleOver = false;
    stateOfGame = stateInstructions;
  }
  else if(_circleOver){
    stateOfGame = statePingPongGame;
  }
}

/*
void detectFiducialMarkPingPongGame(){
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
    for (int i=0;i<tuioObjectList.size();i++) {
       TuioObject tobj = tuioObjectList.get(i);
       println("Object position in screen: " + tobj.getScreenX(width) + ", " + tobj.getScreenY(height));
       println("Paddle position in screen: " + paddleYPos);
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
       while(stateOfGame == stateInstructions){
         println("Instructions desde TUIO");
       }
    }
}*/