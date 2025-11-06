class Sprite
{
  String characterFolder;
  String characterAction;
  String imageFileName;
  String fileExtension;
  int totalSize;
  int spriteScale;
  PImage[] sprites;
  int currentIndex;
  boolean isStop;
  boolean isLoop;
  
  public Sprite(String configFileName)
  {
    loadConfig(configFileName);
    currentIndex = 0;
    isStop = true; // Sprites are stopped by default
    isLoop = true;
  }

  void loadConfig(String configFileName)
  {
    String[] configLine = loadStrings(configFileName);
    if (configLine == null || configLine.length == 0) {
      println("Error: Config file not found or empty: " + configFileName);
      return;
    }
    
    String[] configParameters = split(configLine[0], ' ');
    
    // Format: folder action basename extension frameCount scale
    if (configParameters.length < 6) {
      println("Error: Invalid config line: " + configLine[0]);
      return;
    }
    
    characterFolder = configParameters[0];
    characterAction = configParameters[1];
    imageFileName = configParameters[2];
    fileExtension = configParameters[3];
    totalSize = int(configParameters[4]);
    spriteScale = int(configParameters[5]);
  }

  void loadImageData()
  {
    // This path is relative to the "data" folder
    String path = characterFolder + "/" + characterAction + "/";
    
    sprites = new PImage[totalSize];
    
    for(int i = 0; i < totalSize; i++)
    {
      String fileName = imageFileName + (i+1) + fileExtension;
      println("Loading: " + path + fileName);
      
      // This line automatically looks inside the "data" folder
      sprites[i] = loadImage(path + fileName); 
    }
  }

  void render(float x, float y)
  {
    // Draws the current frame at the given x, y
    if (sprites == null) return; // Not loaded yet
    
    imageMode(CENTER);
    image(sprites[currentIndex], x, y, 
      sprites[currentIndex].width * spriteScale, 
      sprites[currentIndex].height * spriteScale);
  }

  void renderNext(float x, float y)
  {
    // Advances the animation frame and draws it
    if (!isStop)
    {
      currentIndex++;
      if (currentIndex >= totalSize) {
        if (isLoop) {
          currentIndex = 0;
        } else {
          currentIndex = totalSize - 1; // Hold on last frame
          isStop = true; // Stop
        }
      }
    }
    render(x, y);
  }
  
  void play() {
    isStop = false;
  }
  
  void stop() {
    isStop = true;
  }
  
  void reset() {
    currentIndex = 0;
  }
  
  boolean isFinished() {
    return !isLoop && currentIndex >= totalSize - 1;
  }

  float getScaledWidth() {
    if (sprites == null || sprites[0] == null) return 1;
    return sprites[0].width * spriteScale;
  }
  
  float getScaledHeight() {
    if (sprites == null || sprites[0] == null) return 1;
    return sprites[0].height * spriteScale;
  }
}
