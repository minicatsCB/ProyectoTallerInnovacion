/* Ball settings */
float radius = 30;  // The radius of the ball
int xPos;  // The ball position in the X axis
int yPos;  // The ball position in the Y axis
int speed;  // The ball speed
int xDirection;  // (1) -> To the right, (-1) -> To the left

/* Paddle settings */
int paddleWidth;
int paddleHeight;
int paddleXPos;
int paddleYPos;


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
}

void draw(){
  background(0);
  noStroke();
  fill(255, 0, 0);
  ellipse(xPos + (speed * xDirection), yPos, radius, radius);
  xPos = xPos + (speed * xDirection);
  
  fill(0, 255, 0);
  rect(paddleXPos, paddleYPos, paddleWidth, paddleHeight);
  
  fill(0, 0, 255);
  ellipse(paddleXPos, paddleYPos, 5, 5);
  
  // If the ball hits the paddle, change the movement direction
  if(onCollision()){
    print("Chocaste");
    xDirection = xDirection * (-1);
  }
  
  // If the ball hits the side, GAME OVER
  if(xPos > width){
    noLoop();
  }
}

/* Check if the ball hits the paddle
   If so, return true.
   Otherwise return false */
boolean onCollision(){
  if(xPos > paddleXPos - (radius / 2) || xPos < (radius / 2) && (xPos <= paddleXPos + paddleWidth) && (yPos >= paddleYPos) && yPos <= (paddleYPos + paddleHeight)){
    return true;
  }
  
  return false;
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP) {
      movePaddleUp();
    }
    else if (keyCode == DOWN) {
      movePaddleDown();
    }
  }
}

void movePaddleUp(){
  paddleYPos = paddleYPos - 5;
}


void movePaddleDown(){
  paddleYPos = paddleYPos + 5;
}