// The objects in this list are ignored once the have been saved in saveFiducilMark()
ArrayList<TuioObject> tuioObjectListToIgnore = new ArrayList<TuioObject>();
int marksCounter = 0;  // Count the number of marks that has been centered
boolean mark1Centered, mark2Centered ;

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
}

void draw_GameInstructions(){
  background(17, 69, 110);
  int squareSize = 100;
  square1 = new Square(width / 2 + squareSize, height / 2 - squareSize, 30, squareSize);
  square2 = new Square(width / 2 - squareSize - squareSize / 2, height / 2 - squareSize, 30, squareSize);
  
  fill(150, 156, 123);
  rect(square1.xpos, square1.ypos, square1.squareWidth, square1.squareWidth);
  rect(square2.xpos, square2.ypos, square2.squareWidth, square2.squareWidth);
  
   
  fill(0);
  ellipse(square1.xpos  + square1.margin, square1.ypos + square1.margin, 10 , 10);
  ellipse(square1.xpos  + square1.squareWidth - square1.margin, square1.ypos + square1.margin, 10 , 10);
  ellipse(square1.xpos  + square1.margin, square1.ypos + square1.squareWidth - square1.margin, 10 , 10);
  ellipse(square1.xpos  + square1.squareWidth - square1.margin, square1.ypos + square1.squareWidth - square1.margin, 10 , 10);
  
  ellipse(square2.xpos  + square2.margin, square2.ypos + square2.margin, 10 , 10);
  ellipse(square2.xpos  + square2.squareWidth - square2.margin, square2.ypos + square2.margin, 10 , 10);
  ellipse(square2.xpos  + square2.margin, square2.ypos + square2.squareWidth - square2.margin, 10 , 10);
  ellipse(square2.xpos  + square2.squareWidth - square2.margin, square2.ypos + square2.squareWidth - square2.margin, 10 , 10);
  
  detectFiducialMarkInstructions();
  
  // If the two players have been saved, pass to the game
  if(marksCounter == 2){
    stateOfGame = statePingPongGame;
  }
  
  fill(255, 0, 0);
  ellipse(square2.xpos, square2.ypos, 10, 10);
}

void saveFiducialMarks(TuioObject tobj){  
  if(marksCounter != 2){
    println("Quedan marcas por centrar");
    if(!mark1Centered){
        fill(255, 255, 255);
        // Check mark 1
        if(tobj.getSymbolID() == 1){
          if(markCenteredInSquare(square1, tobj)){
            mark1Centered = true;
            tuioObjectListToIgnore.add(tobj);
            marksCounter++;
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
        }
      }
    }
  }
  else{
    println("NO quedan marcas por centrar");
    fill(255, 255, 255);
    if(!mark1Centered)  text("Center fiducial mark 1, please", 0, 100);
    if(!mark2Centered) text("Center fiducial mark 2, please", width-500, 100);
  }
}

boolean markCenteredInSquare(Square targetSquare, TuioObject tobj){
  int markPosX = tobj.getScreenX(width);
  int markPosY = tobj.getScreenY(height);
  if(markPosX > targetSquare.xpos + targetSquare.margin && markPosX < targetSquare.xpos + targetSquare.squareWidth - targetSquare.margin && markPosY > targetSquare.ypos + targetSquare.margin && markPosY < square1.ypos + targetSquare.squareWidth - targetSquare.margin){
      println("Marca fiducial " + tobj.getSymbolID() + " centrada");
      return true;
   }
   else{
     println("Marca fiducial " + tobj.getSymbolID() + " NO centrada");
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
     stroke(0);
     fill(0);
     // Operate the origin of the coordinate system
     pushMatrix();
     // Translate it to the center of the object
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     // Rotate it the received (throgh the camera) angle
     rotate(tobj.getAngle());
     // Draw a rectangle behind the circle
     rect(-30,-30,60,60);
     popMatrix();
     fill(255, 0, 0);
     // Move the ellipse along the TUIO Object
     ellipse(tobj.getScreenX(width), tobj.getScreenY(height), 30, 30);
     pushStyle();
     fill(0,0,255);
     textSize(30);
     text(tobj.getSymbolID() + "  " + tobj.getScreenY(height), tobj.getScreenX(width), tobj.getScreenY(height));  // Object identifier
     popStyle();
     
     // hacer esto solo si estamos en la fase de entrar
     saveFiducialMarks(tobj);
   }
}