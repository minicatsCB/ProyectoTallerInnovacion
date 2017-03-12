int radius = 20; // Radius of the ball
int xPos;  // Its position
int speed = 1;  // How fast is it moving?
int xDir = 1;  // What direction is the ball going?
int score = 0;  // Initial score
int lives = 3;  // Number of lives you start with
boolean lost = false;  // Have you lost yet?


void setup(){
  size(400, 400);
  // Center the ball (in X axis)
  xPos = width/2;
  fill(0, 255, 0);
  textSize(12);  
}


void draw(){
  background(0);
  // Draw the ball
  ellipse(xPos, height/2, radius * 2, radius * 2);
  xPos = xPos + (speed * xDir);
  // Did the ball hit the side?
  if(xPos > width - radius || xPos < radius){
    xDir = xDir * -1;  // Change direction!
  }
  text("Score: " + score, 10, 10);
  text("Lives: " + lives, width - 80, 10);
  // Check if we have lost the game
  if(lives <= 0){
    textSize(20);
    text("Click to Restart", 125, 100);
    noLoop();  // Stop the game!
    lost = true;
    textSize(12);    
  }
}


void mousePressed(){
  // Did we hit the target?
  // If so, increase the score and the speed
  if(dist(mouseX, mouseY, xPos, 200) <= radius){
    score = score + 10;
    speed = speed + 1;
  }
  else{
    // Decrease the speed in order to make easier the game
    // Also decrease the number of lives
    if(speed > 1){
      speed = speed - 1;
    }
    lives = lives - 1;
    
    // If we lost the game, reset it
    if(lost == true){
      speed = 1;
      lives = 3;
      score = 0;
      xPos = width/2;
      xDir = 1;
      lost = false;
      loop();
    }
  }
}