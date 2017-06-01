// The objects in this list are ignored once the have been saved in saveFiducilMark()
ArrayList<TuioObject> tuioObjectListToIgnore = new ArrayList<TuioObject>();
int marksCounter = 0;  // Count the number of marks that has been centered
boolean mark1Centered, mark2Centered;  // Has each fiducial mark been centered?
boolean player1SkinSelected, player2SkinSelected;  // Has each player selected a skin?
int timeBefore;  // Time counter for selecting skin
int selectionTime;  // Time the user has to choose a skin (in milliseconds)

// Countdown timer
private static final byte countdown = 5;
private static int seconds, startTime;

PImage selector;

class Square{
  int xpos, ypos;  // The position of the square that wait for the fiducial mark
  int margin;  // The distance from the borders of the original square to the borders of the smaller one
  int squareWidth;  // The size of the original square
  int asignedPlayer;  // The player which the squre is asigned to
  
  public Square(int asignedPlayer, int xpos, int ypos, int margin, int squareWidth){
    this.asignedPlayer = asignedPlayer;
    this.xpos = xpos;
    this.ypos = ypos;
    this.margin = margin;
    this.squareWidth = squareWidth;
  }
}

Square square1, square2;

void setup_GameInstructions(){
  selector = loadImage("selector.png");
  mark1Centered = false;
  mark2Centered = false;
  selectionTime = 5000;
  int squareSize = 100;
  square1 = new Square(1, (width / 2 - squareSize - squareSize / 2) - 100, height / 2 - squareSize, 30, squareSize);
  square2 = new Square(2, (width / 2 + squareSize) + 100, height / 2 - squareSize, 30, squareSize);
}

void draw_GameInstructions(){
  background(0);  
  
  drawSquare(square1);
  drawSquare(square2);
  
  detectFiducialMarkInstructions();
  
  // If the two players have been saved, pass to the game
  if(marksCounter == 2){
    textSize(50);
    seconds = startTime - millis()/1000;
    if (seconds < 0) startTime = millis()/1000 + countdown;
    else text("Choose a skin, please ( " + seconds + " )", square1.xpos, square1.ypos + 300);
    if(player1SkinSelected && player2SkinSelected){
      start.trigger();
      start.trigger();
      stateOfGame = statePingPongGame;
    }
  }
}

void drawSquare(Square square){
  if(square.asignedPlayer == 0) fill(218, 247, 166);
  if(square.asignedPlayer == 1) fill(243, 156, 18);
  if(square.asignedPlayer == 2) fill(255, 87, 51);
  noStroke();
  rect(square.xpos, square.ypos, square.squareWidth, square.squareWidth);
  fill(0);
  ellipse(square.xpos  + square.margin, square.ypos + square.margin, 10 , 10);
  ellipse(square.xpos  + square.squareWidth - square.margin, square.ypos + square.margin, 10 , 10);
  ellipse(square.xpos  + square.margin, square.ypos + square.squareWidth - square.margin, 10 , 10);
  ellipse(square.xpos  + square.squareWidth - square.margin, square.ypos + square.squareWidth - square.margin, 10 , 10);
}

// We only need the position of the TUIO object in order to know its rotation
void chooseSkin(TuioObject tobj){
  imageMode(CENTER);
  // Draw images around the square
  float r = height * 0.2;
  float theta = 0;
  for(int i = 0; i < skins.size(); i++){
    image(skins.get(i), r * cos(theta), r * sin(theta));
    theta += TWO_PI/skins.size();
  }
  
  // Draw an arc from center to each image
  fill(255);
  pushMatrix();
  rotate(tobj.getAngle());
  popMatrix();
  fill(255, 50);
  noStroke();
  // Right image
  if(tobj.getAngleDegrees() <= (45) || tobj.getAngleDegrees() >= (315)){
    arc(0, 0, 500, 500, -QUARTER_PI, QUARTER_PI);
    // If a number of seconds have elapsed, select the skin
    if(millis() - timeBefore > selectionTime){
      // Player 1 selects right image
      if(tobj.getSymbolID() == 1 && !player1SkinSelected){
        player1 = skins.get(0);
        player1SkinSelected = true;
      }
      // Player 2 selects right image
      if(tobj.getSymbolID() == 2 && !player2SkinSelected){
        player2 = skins.get(0);
        player2SkinSelected = true;
      }
    }
  }
  // Down image
  else if(tobj.getAngleDegrees() >= (45) && tobj.getAngleDegrees() <= (135)){
    arc(0, 0, 500, 500, QUARTER_PI, HALF_PI + QUARTER_PI);
    // If number of seconds have elapsed, select the skin
    if(millis() - timeBefore > 10000){
      if(tobj.getSymbolID() == 1 && !player1SkinSelected){
        player1 = skins.get(1);
        player1SkinSelected = true;
      }
      if(tobj.getSymbolID() == 2 && !player2SkinSelected){
        player2 = skins.get(1);
        player2SkinSelected = true;
      }
    }
  }
  // Left image
  else if(tobj.getAngleDegrees() >= (135) && tobj.getAngleDegrees() <= (225)){
    arc(0, 0, 500, 500, HALF_PI + QUARTER_PI, PI + QUARTER_PI);
    // If a number of seconds have elapsed, select the skin
    if(millis() - timeBefore > selectionTime){
      if(tobj.getSymbolID() == 1 && !player1SkinSelected){
        player1 = skins.get(2);
        player1SkinSelected = true;
      }
      if(tobj.getSymbolID() == 2 && !player2SkinSelected){
        player2 = skins.get(2);
        player2SkinSelected = true;
      }
    }
  }
  // Up image
  else{
    arc(0, 0, 500, 500, PI + QUARTER_PI, PI + QUARTER_PI + HALF_PI);
    // If a number seconds have elapsed, select the skin
    if(millis() - timeBefore > selectionTime){
      if(tobj.getSymbolID() == 1 && !player1SkinSelected){
        player1 = skins.get(3);
        player1SkinSelected = true;
      }
      if(tobj.getSymbolID() == 2 && !player2SkinSelected){
        player2 = skins.get(3);
        player2SkinSelected = true;
      }
    }
  }
  fill(0);
  imageMode(CORNER);
}

void saveFiducialMarks(TuioObject tobj){  
  if(marksCounter != 2){
    //println("Quedan marcas por centrar");
    if(!mark1Centered){
        fill(255, 255, 255);
        textFont(fontCenterMark);
        text("Center fiducial mark 1, please", square1.xpos - 150, square1.ypos - 100);
        // Check mark 1
        if(tobj.getSymbolID() == 1){
          if(markCenteredInSquare(square1, tobj)){
            correct.trigger();
            mark1Centered = true;
            tuioObjectListToIgnore.add(tobj);
            marksCounter++;
            // Check if all marks have been saved to start a time counter
            if(marksCounter == 2){
              timeBefore = millis();
              startTime = millis()/1000 + countdown;  // Start countdown timer
            }
          }
        }
    }
    if(!mark2Centered){
      fill(255, 255, 255);
      textFont(fontCenterMark);
      text("Center fiducial mark 2, please", square2.xpos - 150, square2.ypos - 100);
      if(tobj.getSymbolID() == 2){
        if(markCenteredInSquare(square2, tobj)){
          correct.trigger();
          mark2Centered = true;
          tuioObjectListToIgnore.add(tobj);
          marksCounter++;
          if(marksCounter == 2){
              timeBefore = millis();
            }
        }
      }
    }
  }
}

boolean markCenteredInSquare(Square targetSquare, TuioObject tobj){
  int markPosX = tobj.getScreenX(width);
  int markPosY = tobj.getScreenY(height);
  // Fiducial mark is centered when it is inside the square
  if(markPosX > targetSquare.xpos + targetSquare.margin && markPosX < targetSquare.xpos + targetSquare.squareWidth - targetSquare.margin && markPosY > targetSquare.ypos + targetSquare.margin && markPosY < square1.ypos + targetSquare.squareWidth - targetSquare.margin){
      return true;
   }
   else{
     return false;
   }
}

void detectFiducialMarkInstructions(){
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = tuioObjectList.get(i);  // Current mark
     // If we have already saved the mark, skip it
     if(tuioObjectListToIgnore != null && tuioObjectListToIgnore.contains(tobj)){
       continue;
     }
    // println("Object position in screen: " + tobj.getScreenX(width) + ", " + tobj.getScreenY(height));
     drawTuioObject(tobj);
     
     // Call this from here because we need the current TUIO object
     saveFiducialMarks(tobj);
   }
}

void drawTuioObject(TuioObject tobj){
   stroke(0);
   fill(0);
   pushMatrix();
   // After saving fiducial marks (marksCounter == 2), choose a skin, this is, anchor the TUIO objects to a position
   // In this case, the position is the center of the square
   if(marksCounter == 2){
     int centerxpos, centerypos;  // Square center
     if(tobj.getSymbolID() == 1){
       centerxpos = square1.xpos + square1.squareWidth/2;
       centerypos = square1.ypos + square1.squareWidth/2;
       translate(centerxpos, centerypos);
       chooseSkin(tobj);
       fill(0);
     }
     if(tobj.getSymbolID() == 2){
       centerxpos = square2.xpos + square2.squareWidth/2;
       centerypos = square2.ypos + square2.squareWidth/2;
       translate(centerxpos, centerypos);
       chooseSkin(tobj);
       fill(0);
     }
     // Rotate it the received (throgh the camera) angle
     rotate(tobj.getAngle());
     // Draw a rectangle behind the circle
     //rect(-30,-30,60,60);
     imageMode(CENTER);
     rotate(radians(90));  // Adjust rotation image to go along the TUIO object
     image(selector, 0, 0);
     imageMode(CORNER);
   }
   else{
     // Translate it to the center of the object
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
   }
   popMatrix();
   fill(255, 0, 0);
   if(marksCounter != 2){
     // Move the ellipse along the TUIO Object
     ellipse(tobj.getScreenX(width), tobj.getScreenY(height), 30, 30);
     fill(255);
     textSize(20);
     text(tobj.getSymbolID(), tobj.getScreenX(width) - 5, tobj.getScreenY(height) + 5);  // Object identifier
   }
   pushStyle();
   popStyle();
}