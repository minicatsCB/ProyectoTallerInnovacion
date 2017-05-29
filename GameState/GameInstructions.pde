// The objects in this list are ignored once the have been saved in saveFiducilMark()
ArrayList<TuioObject> tuioObjectListToIgnore = new ArrayList<TuioObject>();
int marksCounter = 0;  // Count the number of marks that has been centered
boolean mark1Centered, mark2Centered;  // Has each fiducial mark been centered?
boolean player1SkinSelected, player2SkinSelected;  // Has each player selected a skin?
int timeBefore;  // Time counter for selecting skin
int selectionTime;  // Time the user has to choose a skin (in milliseconds)

class Square{
  int xpos, ypos;  // The position of the square that wait for the fiducial mark
  int margin;  // The distance from the borders of the original square to the borders of the smaller one
  int squareWidth;  // The size of the original square
  
  public Square(int xpos, int ypos, int margin, int squareWidth){
    this.xpos = xpos;
    this.ypos = ypos;
    this.margin = margin;
    this.squareWidth = squareWidth;
  }
}

Square square1, square2;

void setup_GameInstructions(){
  mark1Centered = false;
  mark2Centered = false;
  selectionTime = 5000;
}

void draw_GameInstructions(){
  background(17, 69, 110);
  int squareSize = 100;
  square1 = new Square((width / 2 + squareSize) + 100, height / 2 - squareSize, 30, squareSize);
  square2 = new Square((width / 2 - squareSize - squareSize / 2) - 100, height / 2 - squareSize, 30, squareSize);  
  
  drawSquare(square1);
  drawSquare(square2);
  
  detectFiducialMarkInstructions();
  
  // If the two players have been saved, pass to the game
  if(marksCounter == 2 && (player1SkinSelected && player2SkinSelected)){
    stateOfGame = statePingPongGame;
  }
  
  fill(255, 0, 0);
  ellipse(square2.xpos, square2.ypos, 10, 10);
}

void drawSquare(Square square){
  fill(150, 156, 123);
  rect(square.xpos, square.ypos, square.squareWidth, square.squareWidth);
  fill(0);
  ellipse(square.xpos  + square.margin, square.ypos + square.margin, 10 , 10);
  ellipse(square.xpos  + square.squareWidth - square.margin, square.ypos + square.margin, 10 , 10);
  ellipse(square.xpos  + square.margin, square.ypos + square.squareWidth - square.margin, 10 , 10);
  ellipse(square.xpos  + square.squareWidth - square.margin, square.ypos + square.squareWidth - square.margin, 10 , 10);
}

// We only need the position of the square
void chooseSkin(TuioObject tobj, Square square){
  int centerxpos, centerypos;
  centerxpos = square.xpos + square.squareWidth/2;
  centerypos = square.ypos + square.squareWidth/2;
  imageMode(CENTER);
  // Draw images around the square
  float r = height * 0.2;
  float theta = 0;
  for(int i = 0; i < skins.size(); i++){
    image(skins.get(i), r * cos(theta), r * sin(theta));
    theta += TWO_PI/skins.size();
  }
  
  float beta = 0;
  // Draw an arc from center to each image
  fill(255);
  pushMatrix();
  rotate(tobj.getAngle());
  popMatrix();
  //println("tobjAngle: " + tobj.getAngleDegrees());
  fill(255, 50);
  noStroke();
  println("Time before: " + timeBefore);
  if(tobj.getAngleDegrees() <= (45) || tobj.getAngleDegrees() >= (315)){
    //println("Derecha");
    arc(0, 0, 500, 500, -QUARTER_PI, QUARTER_PI);
    // If a number of seconds have elapsed, select the skin
    if(millis() - timeBefore > selectionTime){
      println("Tiempo pasado: " + (millis() - timeBefore));
      if(tobj.getSymbolID() == 1 && !player1SkinSelected){
        player1 = skins.get(0);
        player1SkinSelected = true;
        println("Derecha seleccionada por 1!");
      }
      if(tobj.getSymbolID() == 2 && !player2SkinSelected){
        player2 = skins.get(0);
        player2SkinSelected = true;
        println("Derecha seleccionada por 2");
      }
    }
  }
  else if(tobj.getAngleDegrees() >= (45) && tobj.getAngleDegrees() <= (135)){
   // println("Abajo");
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
  else if(tobj.getAngleDegrees() >= (135) && tobj.getAngleDegrees() <= (225)){
    //println("Izquierda");
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
  else{
   // println("Arriba");
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
        // Check mark 1
        if(tobj.getSymbolID() == 1){
          if(markCenteredInSquare(square1, tobj)){
            mark1Centered = true;
            tuioObjectListToIgnore.add(tobj);
            marksCounter++;
            // Check if all marks have been saved to start a time counter
            if(marksCounter == 2){
              timeBefore = millis();
            }
          }
        }
    }
    if(!mark2Centered){
      fill(255, 255, 255);
      text("Center fiducial mark 2, please", width-500, 100);
      if(tobj.getSymbolID() == 2){
        if(markCenteredInSquare(square2, tobj)){   
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
  else{
    fill(255, 255, 255);
    if(!mark1Centered) text("Center fiducial mark 1, please", 0, 100);
    if(!mark2Centered) text("Center fiducial mark 2, please", width-500, 100);
  }
}

boolean markCenteredInSquare(Square targetSquare, TuioObject tobj){
  int markPosX = tobj.getScreenX(width);
  int markPosY = tobj.getScreenY(height);
  if(markPosX > targetSquare.xpos + targetSquare.margin && markPosX < targetSquare.xpos + targetSquare.squareWidth - targetSquare.margin && markPosY > targetSquare.ypos + targetSquare.margin && markPosY < square1.ypos + targetSquare.squareWidth - targetSquare.margin){
      //println("Marca fiducial " + tobj.getSymbolID() + " centrada");
      return true;
   }
   else{
     //println("Marca fiducial " + tobj.getSymbolID() + " NO centrada");
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
     
     // hacer esto solo si estamos en la fase de entrar
     saveFiducialMarks(tobj);
   }
}

void drawTuioObject(TuioObject tobj){
   stroke(0);
   fill(0);
   // Operate the origin of the coordinate system
   pushMatrix();
   // After saving fiducial marks, choose a skin, this is, anchor the TUIO objects to a position
   // In this case, the position is the center of the squares
   if(marksCounter == 2){
     int centerxpos, centerypos;  // Square center
     if(tobj.getSymbolID() == 1){
       centerxpos = square1.xpos + square1.squareWidth/2;
       centerypos = square1.ypos + square1.squareWidth/2;
       translate(centerxpos, centerypos);
       chooseSkin(tobj, square1);
       fill(0);
     }
     if(tobj.getSymbolID() == 2){
       centerxpos = square2.xpos + square2.squareWidth/2;
       centerypos = square2.ypos + square2.squareWidth/2;
       translate(centerxpos, centerypos);
       chooseSkin(tobj, square2);
       fill(0);
     }
   }
   else{
     // Translate it to the center of the object
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
   }
   // Rotate it the received (throgh the camera) angle
   rotate(tobj.getAngle());
   // Draw a rectangle behind the circle
   rect(-30,-30,60,60);
   popMatrix();
   fill(255, 0, 0);
   if(marksCounter != 2){
     // Move the ellipse along the TUIO Object
     ellipse(tobj.getScreenX(width), tobj.getScreenY(height), 30, 30);
     fill(0,0,255);
     textSize(30);
     text(tobj.getSymbolID() + "  " + tobj.getScreenY(height), tobj.getScreenX(width), tobj.getScreenY(height));  // Object identifier
   }
   pushStyle();
   popStyle();
}