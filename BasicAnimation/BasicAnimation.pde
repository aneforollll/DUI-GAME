Sprite idleSprite;

void setup()
{
  size(512,512);
  background(255,204,0);
  frameRate(4);
   
  idleSprite = new Sprite("IdleConfig.txt");
  idleSprite.loadImageData();
}
void draw()
{
  background(255, 204, 0);
  idleSprite.play();
}
void keyPressed()
{
  if(keyPressed && (key == 'F' || key == 'f'))
  {
   idleSprite.isLoop = !idleSprite.isLoop; 
  }
}
