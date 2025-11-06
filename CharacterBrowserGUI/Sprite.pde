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
<<<<<<< Updated upstream
  
=======
  boolean finished;

>>>>>>> Stashed changes
  public Sprite(String configFileName)
  {
    loadConfig(configFileName);
    currentIndex = 0;
<<<<<<< Updated upstream
    isStop = true; // Sprites are stopped by default
    isLoop = true;
=======
    isStop = true;
    isLoop = true;
    finished = false;
>>>>>>> Stashed changes
  }

  void loadConfig(String configFileName)
  {
    String[] configLine = loadStrings(configFileName);
    if (configLine == null || configLine.length == 0) {
      println("Error: Config file not found or empty: " + configFileName);
      return;
    }
<<<<<<< Updated upstream
    
    String[] configParameters = split(configLine[0], ' ');
    
    // Format: folder action basename extension frameCount scale
=======

    String[] configParameters = split(configLine[0], ' ');

>>>>>>> Stashed changes
    if (configParameters.length < 6) {
      println("Error: Invalid config line: " + configLine[0]);
      return;
    }
<<<<<<< Updated upstream
    
=======

>>>>>>> Stashed changes
    characterFolder = configParameters[0];
    characterAction = configParameters[1];
    imageFileName = configParameters[2];
    fileExtension = configParameters[3];
    totalSize = int(configParameters[4]);
    spriteScale = int(configParameters[5]);
  }

  void loadImageData()
  {
<<<<<<< Updated upstream
    // This path is relative to the "data" folder
    String path = characterFolder + "/" + characterAction + "/";
    
    sprites = new PImage[totalSize];
    
    for(int i = 0; i < totalSize; i++)
    {
      String fileName = imageFileName + (i+1) + fileExtension;
      println("Loading: " + path + fileName);
      
      // This line automatically looks inside the "data" folder
      sprites[i] = loadImage(path + fileName); 
=======
    String path = characterFolder + "/" + characterAction + "/";
    sprites = new PImage[totalSize];

    for (int i = 0; i < totalSize; i++)
    {
      String fileName = imageFileName + (i+1) + fileExtension;
      sprites[i] = loadImage(path + fileName);

      if (sprites[i] == null) {
        println("Missing image: " + path + fileName);
      }
>>>>>>> Stashed changes
    }
  }

  void render(float x, float y)
  {
<<<<<<< Updated upstream
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
=======
    if (sprites == null) return;
    PImage frame = sprites[currentIndex];
    if (frame == null) return;

    imageMode(CENTER);
    image(frame, x, y, frame.width * spriteScale, frame.height * spriteScale);
  }

  void renderNext(float x, float y)
{
  // Safety guards
  if (sprites == null || totalSize <= 0) return;
  if (currentIndex < 0) currentIndex = 0;
  if (currentIndex >= totalSize) currentIndex = totalSize - 1;

  // Draw current frame (if available)
  if (sprites[currentIndex] != null) {
    render(x, y);
  } else {
    // optional placeholder if image missing
    // fill(120); rect(x - 16, y - 16, 32, 32);
  }

  // Advance frame AFTER rendering so first frame is shown
  if (!isStop) {
    currentIndex++;

    if (currentIndex >= totalSize) {
      if (isLoop) {
        currentIndex = 0;
      } else {
        // Hold at last frame and mark finished
        currentIndex = totalSize - 1;
        finished = true;
        isStop = true;     // stop advancing further
      }
    }
  }
}


  void play() {
    isStop = false;
    finished = false;
  }

  void stop() {
    isStop = true;
  }

  void reset() {
    currentIndex = 0;
    isStop = false;
    finished = false;
  }

  boolean isFinished() {
    return finished;
  }

  float getScaledWidth() {
    return (sprites == null || sprites[0] == null) ? 1 : sprites[0].width * spriteScale;
  }

  float getScaledHeight() {
    return (sprites == null || sprites[0] == null) ? 1 : sprites[0].height * spriteScale;
>>>>>>> Stashed changes
  }
}
