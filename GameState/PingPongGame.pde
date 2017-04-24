/* Ball settings */
float radius = 15;  // The radius of the ball
int xPos;  // The ball position in the X axis
int yPos;  // The ball position in the Y axis
int speed;  // The ball speed
int xDirection;  // (1) -> To the right, (-1) -> To the left

/* Paddle settings */
int paddleWidth;
int paddleHeight;
int paddleXPos;
int paddleYPos;

boolean stopLoop = false; // If true, stop drawing


void setup_PingPongGame(){
  // Start from the center of the screen
  xPos = width / 2;
  yPos = height / 2;
  // Start moving to the right
  xDirection = 1;
  // Start moving at this speed
  speed = 2;
  // Draw a paddle
  paddleWidth = 20;
  paddleHeight = 60;
  paddleXPos = width - paddleWidth;
  paddleYPos = height / 2;
}

void draw_PingPongGame(){
  background(255);
  noStroke();
  fill(255, 0, 0);
  // Draw the ball
  ellipse(xPos + (speed * xDirection), yPos, radius * 2, radius * 2);
  xPos = xPos + (speed * xDirection);
  fill(0, 255, 0);
  ellipse(xPos, yPos, 10, 10);
  
  // Draw the paddle
  fill(0, 255, 0);
  rect(paddleXPos, paddleYPos, paddleWidth, paddleHeight);
  fill(0, 0, 255);
  ellipse(paddleXPos, paddleYPos, 10, 10);
  // println("xPos: " + xPos);
  
  // If the ball hits the paddle, change the movement direction
  if(onCollision()){
    xDirection = xDirection * (-1);
  }
  
  detectFiducialMarkPingPongGame();
  
  // If the ball hits the side, GAME OVER
  if(xPos >= width - radius ||xPos <= radius){
    stopLoop = true;
    noLoop();
    println("YA");
  }
}

/* 
  Check if the ball hits the paddle.
  No parameters
  Return: If hit, return true. Otherwise return false
*/
boolean onCollision(){
  //if(xPos > paddleXPos - (radius / 2) || xPos < (radius / 2) && (xPos <= paddleXPos + paddleWidth) && (yPos >= paddleYPos) && yPos <= (paddleYPos + paddleHeight)){
  if(xPos >= width - paddleWidth - radius){
    return true;
  }
  return false;
}

/* 
  Move the paddle 1 based on the TUIO object position
  Parameters: the object position in Y axis
  Return: nothing
*/
void movePaddle1(int tYPos){
  paddleYPos = tYPos;
  // Check if the ball has reached the top of the screen
  // If so, stop the ball from moving up
    if(paddleYPos <= 0){
      paddleYPos = 0;
    }
    // Check if the ball has reached the bottom of the screen
    // If so, stop the ball from moving down
    else if(paddleYPos + paddleHeight >= height){
      paddleYPos = height - paddleHeight;
    }
    else{
      paddleYPos = tYPos;
    }
}

/* 
  Move the paddle based on the TUIO object position
  Parameters: the object position in Y axis
  Return: nothing
*/
void movePaddle2(int tYPos){
  paddleYPos = tYPos;
  // Check if the ball has reached the top of the screen
  // If so, stop the ball from moving up
    if(paddleYPos <= 0){
      paddleYPos = 0;
    }
    // Check if the ball has reached the bottom of the screen
    // If so, stop the ball from moving down
    else if(paddleYPos + paddleHeight >= height){
      paddleYPos = height - paddleHeight;
    }
    else{
      paddleYPos = tYPos;
    }
}

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
}