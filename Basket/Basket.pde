float xSpeed = 5;
float ySpeed = 2;
float xPosition = 50;
float yPosition = 50;
 
 
float ballWidth = 30;
float ballHeight = 30;
 
 
void setup()
{
 
  size(600, 400);
  background(255);
  smooth();
  setup_TUIO();
}
 
void draw()
{ 
  text("Basketball ",200,50);
  textSize(50);
  line(600,100,500,100);
  fill(255,150);
  rect(0, 0,
  width, height);
 
  fill(255, 100, 0);
  ellipse(xPosition, yPosition, 50, 50);
 
  ySpeed +=1;
  xSpeed *=.9975;
  //xPosition += xSpeed;
  //yPosition += ySpeed;
 
// Cambia la dirección después de golpear a la pared derecha
  if (xPosition > width-ballWidth/2)
  {
    xPosition=width-ballWidth/2;
    xSpeed=-xSpeed;
  }
 
// Cambia de dirección después de golpear la pared izquierda
  if (xPosition<ballWidth/2)
  {
    xPosition=ballWidth/2;   
    xSpeed=-xSpeed;
  }
 
// Pierde altura después de cada bote
  if (yPosition > height-ballHeight/2)
  {
    yPosition=height-ballHeight/2;
    ySpeed = -ySpeed*.9;
  }
 
// Pierde veolicdad más rápidamente mietras va por el suelo.
  if (yPosition > height-ballHeight/2-1)
  {
    xSpeed *=.9975;
  }
  draw_TUIO();
}
 
// Tirar la pelota
//void mouseDragged()
//{
//  xPosition = mouseX;
//  yPosition = mouseY;
//  xSpeed = mouseX - pmouseX;
//  ySpeed = mouseY - pmouseY;
//}

void move_Ball(int posX, int posY){
  xPosition=posX;
  yPosition=posY;
    
}