int _circleX, _circleY;  // Position of circle button
int _circleSize = 90;  // Diameter of circle
color _circleColor, _circleHighlight;  // Circle aesthetics
boolean _circleOver;  // Is the mouse over the button?
int squarePosX, squarePosY;  // The position of the square that wait for the fiducial mark
// The objects in this list are ignored once the have been saved in saveFiducilMark()
ArrayList<TuioObject> tuioObjectListToIgnore = new ArrayList<TuioObject>();
int marksCounter = 0;  // Count the number of marks that has been centered

void setup_GameInstructions(){
  _circleColor = color(160);
  _circleHighlight = color(210);
  _circleX = width / 2 + 50;
  _circleY = height / 2 + 50;
}

void draw_GameInstructions(){
  _update();
  background(0, 255, 0);
  
  // If the mouse is over circle, change its color
  if(_circleOver){
    fill(_circleHighlight);
  }
  else{
    fill(_circleColor);
  }
  
  stroke(0);
  ellipse(_circleX, _circleY, _circleSize, _circleSize);
  
  fill(0, 255, 0);
  text("Start", _circleX, _circleY);
  
  fill(150, 156, 123);
  rect(width / 2 - 100, height / 2 - 100, 100, 100);
  squarePosX = width / 2 - 100;
  squarePosY = height / 2 - 100;
  
   
  fill(0);
  ellipse(squarePosX  + 30, squarePosY + 30, 10 , 10);  // 30 es el margen
  ellipse(squarePosX  + 100 - 30, squarePosY + 30, 10 , 10);  // 100 es el largo del rectángulo original
  ellipse(squarePosX  + 30, squarePosY + 100 - 30, 10 , 10);
  ellipse(squarePosX  + 100 - 30, squarePosY + 100 - 30, 10 , 10);
  
  detectFiducialMarkInstructions();
  
  if(marksCounter == 2){
     // Pasar a PingPongGame
    stateOfGame = statePingPongGame;
  }
  
}

void saveFiducialMark(TuioObject tobj){  
  fill(255, 255, 255);
  text("Center fiducial mark 1, please", 0, 0);
  int markPosX = tobj.getScreenX(width);
  int markPosY = tobj.getScreenX(height);
  
  if(marksCounter != 2){
    println("Quedan marcas por centrar");
    if(markPosX > squarePosX + 30 && markPosX < squarePosX + 100 - 30 && markPosY > squarePosY + 30 && markPosY < squarePosY + 100 - 30){
      println("Marca fiducial" + tobj.getSymbolID() + " centrada");
      tuioObjectListToIgnore.add(tobj);
      marksCounter++;
    }
  }
  else{
    print("NO quedan marcas por centrar");
  }
}

void detectFiducialMarkInstructions(){
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0;i<tuioObjectList.size();i++) {
     TuioObject tobj = tuioObjectList.get(i);
     if(tuioObjectListToIgnore != null && tuioObjectListToIgnore.contains(tobj)){
       continue;
     }
     println("Object position in screen: " + tobj.getScreenX(width) + ", " + tobj.getScreenY(height));
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
     
     saveFiducialMark(tobj);
   }
}

/*
  Check if the mouse is inside the circle
  We could merge this method with overCircle,
  but just in case in the future we want add
  extra buttons
*/
void _update(){
  if(_overCircle(_circleX, _circleY, _circleSize)){
    _circleOver = true;
  }
  else{
    _circleOver = false;
  }
}

/*
  Check if the mouse is inside the circle
  If so, return true, otherwise, return false
*/
boolean _overCircle(int x, int y, int diameter){
  float distX = x - mouseX;
  float distY = y - mouseY;
  if(sqrt(sq(distX) + sq(distY)) < diameter / 2){
    return true;
  }
  else{
    return false;
  }
}