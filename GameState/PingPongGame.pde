/* Ball settings */
float radius = 15;  // The radius of the ball
int xPos;  // The ball position in the X axis
int yPos;  // The ball position in the Y axis
int xspeed, yspeed;  // The ball speed
int xdirection, ydirection;  // (1) -> To the right, (-1) -> To the left

/* Paddle settings */
int paddleWidth;
int paddleHeight;
int paddleXPos;
int paddleYPos;

int paddle2Width;
int paddle2Height;
int paddle2XPos;
int paddle2YPos;

boolean stopLoop = false; // If true, stop drawing

PImage bg;

void setup_PingPongGame(){
  bg = loadImage("background_0.jpg");
  // Start from the center of the screen
  xPos = width / 2;
  yPos = height / 2;
  // Start moving to the right
  xdirection = 1;
  ydirection = 1;
  // Start moving at this speed
  xspeed = 3;
  yspeed = 3;
  // Draw a paddle
  paddleWidth = 20;
  paddleHeight = 60;
  paddleXPos = width - paddleWidth;
  paddleYPos = height / 2;
  
  // Draw a paddle2
  paddle2Width = 20;
  paddle2Height = 60;
  paddle2XPos = 0;
  paddle2YPos = height / 2;
}

void draw_PingPongGame(){
  background(bg);
  noStroke();
  fill(255, 0, 0);
  // Draw the ball
  xPos = xPos + (xspeed * xdirection);
  yPos = yPos + (yspeed * ydirection);
  if (xPos > width-radius || xPos < radius) {
    xdirection *= -1;
  }
  if (yPos > height-radius || yPos < radius) {
    ydirection *= -1;
  }
  
  fill(255, 0, 0);
  ellipse(xPos, yPos, radius * 2, radius * 2);
  
  // Draw the paddle
  fill(255);
  rect(paddleXPos, paddleYPos, paddleWidth, paddleHeight);
  fill(0, 0, 255);
  ellipse(paddleXPos, paddleYPos, 10, 10);
  
  // Draw the paddle
  fill(255);
  rect(paddle2XPos, paddle2YPos, paddle2Width, paddle2Height);
  fill(0, 0, 255);
  ellipse(paddle2XPos, paddle2YPos, 10, 10);
  
  // If the ball hits the paddle, change the movement direction
  if(onCollision()){
    xdirection = xdirection * (-1);
  }
  
  detectFiducialMarkPingPongGame();
  
  float x1_1 = width - paddleWidth - radius;
  fill(0);
  drawLine(x1_1, height, x1_1, 0);
  float x1_2 = width - paddleWidth;
  drawLine(x1_2, height,x1_2, 0);
  
  float x2_1 = paddle2Width + radius;
  fill(0);
  drawLine(x2_1, height, x2_1, 0);
  float x2_2 = paddleWidth;
  drawLine(x2_2, height,x2_2, 0);
  
  
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
      if(yPos >= paddleYPos && yPos <= paddleYPos + paddleHeight){
        return true;
      }
  }else if (xPos >= paddle2Width + radius && xPos <= paddle2Width + radius){
      if(yPos >= paddle2YPos && yPos <= paddle2YPos + paddle2Height){
        return true;
      }
    }
  return false;
}

void drawLine(float x1, float y1, float x2,float y2){
  line(x1, y1, x2, y2);
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
  paddle2YPos = tYPos;
  // Check if the ball has reached the top of the screen
  // If so, stop the ball from moving up
    if(paddle2YPos <= 0){
      paddle2YPos = 0;
    }
    // Check if the ball has reached the bottom of the screen
    // If so, stop the ball from moving down
    else if(paddle2YPos + paddle2Height >= height){
      paddle2YPos = height - paddle2Height;
    }
    else{
      paddle2YPos = tYPos;
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
       if(tobj.getSymbolID() == tuioObjectListToIgnore.get(0).getSymbolID()){
         int gameYPos1 = (int)map(tobj.getScreenY(height), 60, height-60, 0, height);
         constrain(gameYPos1, 0, height);
         movePaddle1(gameYPos1);
       }
       else{
         int gameYPos2 = (int)map(tobj.getScreenY(height), 60, height-60, 0, height);
         constrain(gameYPos2, 0, height);
         movePaddle2(gameYPos2);
       }
       while(stateOfGame == stateInstructions){
         println("Instructions desde TUIO");
       }
    }
}