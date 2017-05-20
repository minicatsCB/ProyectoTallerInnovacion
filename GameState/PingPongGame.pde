
class Ball{
  float radius;  // The radius of the ball
  int xpos, ypos;  // The position of the ball in the X and Y axis
  int xspeed, yspeed;  // The speed of the ball in the X and Y axis
  int xdir, ydir; // (1) -> To the right/up, (-1) -> To the left/down
  
  Ball(int radius, int xpos, int ypos, int xdir, int ydir, int xspeed, int yspeed){
    this.radius = radius;
    this.xpos = xpos;
    this.ypos = ypos;
    this.xdir = xdir;
    this.ydir = ydir;
    this.xspeed = xspeed;
    this.yspeed = yspeed;
  }
  
  public void ToString(){
    println("Radius: " + radius + ", xpos: " + xpos + ", ypos: " + ypos + ", xdir: " + xdir + ", ydir: " + ydir + ", xspeed: " + xspeed + ", yspeed: " + yspeed);
  }
}

class Paddle{
  int paddleWidth, paddleHeight;
  int xpos, ypos;
  int number;
  
  Paddle(int paddleWidth, int paddleHeight, int number){
    this.paddleWidth = paddleWidth;
    this.paddleHeight = paddleHeight;
    this.number = number;
    // Paddle 1 starts in a position different from paddle 2 (and others)
    if(this.number == 1){
      this.xpos = width - this.paddleWidth;
    }
    else{
      this.xpos = 0;
    }
    this.ypos = height / 2;
  }
  
  public void ToString(){
    println("Width: " + paddleWidth + ", height: " + paddleHeight + ", xpos: " + xpos + ", ypos: " + ypos);
  }
}

boolean stopLoop = false; // If true, stop drawing

PImage bg;  // Background image

Ball ball;
Paddle paddle1, paddle2;

void setup_PingPongGame(){
  bg = loadImage("background_0.jpg");
  ball = new Ball(15, width / 2, height / 2, 1, 1, 3, 3);
  paddle1 = new Paddle(20, 60, 1);
  paddle2 = new Paddle(20, 60, 2);
  ball.ToString();
  paddle1.ToString();
  paddle2.ToString();
}

void draw_PingPongGame(){
  background(bg);
  
  noStroke();
  fill(255, 0, 0);
  // Draw the ball
  ball.xpos = ball.xpos + (ball.xspeed * ball.xdir);
  ball.ypos = ball.ypos + (ball.yspeed * ball.ydir);
  
  ellipse(ball.xpos, ball.ypos, ball.radius * 2, ball.radius * 2);
  
  if (ball.xpos > width - ball.radius || ball.xpos < ball.radius) {
    ball.xdir *= -1;
  }
  if (ball.ypos > height - ball.radius || ball.ypos < ball.radius) {
    ball.ydir *= -1;
  }
  
  // Draw the paddle
  fill(255);
  rect(paddle1.xpos, paddle1.ypos, paddle1.paddleWidth, paddle1.paddleHeight);
  fill(0, 0, 255);
  // Draw a reference point
  ellipse(paddle1.xpos, paddle1.ypos, 10, 10);
  
  // Draw the paddle
  fill(255);
  rect(paddle2.xpos, paddle2.ypos, paddle2.paddleWidth, paddle2.paddleHeight);
  fill(0, 0, 255);
  // Draw a reference point
  ellipse(paddle2.xpos, paddle2.ypos, 10, 10);
    
  hasBounced();  
  detectFiducialMarkPingPongGame();
  isGameOver();
}

// If the ball hits the side, GAME OVER
void isGameOver(){
  if(ball.xpos >= width - ball.radius || ball.xpos <= ball.radius){
    stopLoop = true;
    noLoop();
    println("YA");
  }
}

// If the ball hits the paddle, change the movement direction
void hasBounced(){
  if(onCollision()){
    ball.xdir *= -1;
  }
}


//Check if the ball hits the paddle.
//No parameters
//Return: If hit, return true. Otherwise return false
boolean onCollision(){
  if(ball.xpos >= width - paddle1.paddleWidth - ball.radius){
    if(ball.ypos >= paddle1.ypos && ball.ypos <= paddle1.ypos + paddle1.paddleHeight){
      return true;
    }
  }else if (ball.xpos >= paddle2.paddleWidth + ball.radius && ball.xpos <= paddle2.paddleWidth + ball.radius){
      if(ball.ypos >= paddle2.ypos && ball.ypos <= paddle2.ypos + paddle2.paddleHeight){
        return true;
      }
    }
  return false;
}



/* 
  Move the paddle 1 based on the TUIO object position
  Parameters: the object position in Y axis
  Return: nothing
*/
void movePaddle1(int tYPos){
  paddle1.ypos = tYPos;
  // Check if the ball has reached the top of the screen
  // If so, stop the ball from moving up
    if(paddle1.ypos <= 0){
      paddle1.ypos = 0;
    }
    // Check if the ball has reached the bottom of the screen
    // If so, stop the ball from moving down
    else if(paddle1.ypos + paddle1.paddleHeight >= height){
      paddle1.ypos = height - paddle1.paddleHeight;
    }
    else{
      paddle1.ypos = tYPos;
    }
}

/* 
  Move the paddle based on the TUIO object position
  Parameters: the object position in Y axis
  Return: nothing
*/
void movePaddle2(int tYPos){
  paddle2.ypos = tYPos;
  // Check if the ball has reached the top of the screen
  // If so, stop the ball from moving up
    if(paddle2.ypos <= 0){
      paddle2.ypos = 0;
    }
    // Check if the ball has reached the bottom of the screen
    // If so, stop the ball from moving down
    else if(paddle2.ypos + paddle2.paddleHeight >= height){
      paddle2.ypos = height - paddle2.paddleHeight;
    }
    else{
      paddle2.ypos = tYPos;
    }
}

void drawLine(float x1, float y1, float x2,float y2){
  line(x1, y1, x2, y2);
}

void drawLimitLines(){
  float x1_1 = width - paddle1.paddleWidth - ball.radius;
  fill(0);
  drawLine(x1_1, height, x1_1, 0);
  float x1_2 = width - paddle1.paddleWidth;
  drawLine(x1_2, height,x1_2, 0);
  
  float x2_1 = paddle2.paddleWidth + ball.radius;
  fill(0);
  drawLine(x2_1, height, x2_1, 0);
  float x2_2 = paddle2.paddleWidth;
  drawLine(x2_2, height,x2_2, 0);
}

void detectFiducialMarkPingPongGame(){
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
    for (int i=0;i<tuioObjectList.size();i++) {
       TuioObject tobj = tuioObjectList.get(i);
       println("Object position in screen: " + tobj.getScreenX(width) + ", " + tobj.getScreenY(height));
       // println("Paddle position in screen: " + paddle1.ypos);
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
         int gameYPos1 = (int)map(tobj.getScreenY(height), 60, height - 60, 0, height);
         constrain(gameYPos1, 0, height);
         movePaddle1(gameYPos1);
       }
       else{
         int gameYPos2 = (int)map(tobj.getScreenY(height), 60, height - 60, 0, height);
         constrain(gameYPos2, 0, height);
         movePaddle2(gameYPos2);
       }
       while(stateOfGame == stateInstructions){
         println("Instructions desde TUIO");
       }
    }
}