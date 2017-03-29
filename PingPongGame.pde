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


void setup(){
  size(400, 400);
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
  
  setup_TUIO();
}

void draw(){
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
  println("xPos: " + xPos);
  
  // If the ball hits the paddle, change the movement direction
  if(onCollision()){
    xDirection = xDirection * (-1);
  }
  
  draw_TUIO();
  
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
  Move the paddle based on the TUIO object position
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
void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP) {
      paddleYPos = paddleYPos - 5;
      // Check if the ball has reached the top of the screen
      if(paddleYPos <= 0){
        // If so, stop the ball from moving up
        paddleYPos = 0;
      }
    }
    else if (keyCode == DOWN) {
      paddleYPos = paddleYPos + 5;
      // Check if the ball has reached the bottom of the screen
      if(paddleYPos + paddleHeight >= height){
        // If so, stop the ball from moving down
        paddleYPos = height - paddleHeight;
      }
    }
  }
}*/