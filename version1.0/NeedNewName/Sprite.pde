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
  
  boolean finished;
  

  int unitHealth = 100;

  public Sprite(String configFileName)
  {
    loadConfig(configFileName);
    currentIndex = 0;
    isStop = true;
    isLoop = true;
    finished = false;
  }

  void loadConfig(String configFileName)
  {
    String[] configLine = loadStrings(configFileName);
    if (configLine == null || configLine.length == 0) {
      println("Error: Config file not found or empty: " + configFileName);
      return;
    }

    String[] configParameters = split(configLine[0], ' ');

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
    
    if (configParameters.length >= 7) {
      unitHealth = int(configParameters[6]);
    } else {
      println("Warning: " + configFileName + " is missing health. Defaulting to 100.");
    }
  }
  
  int getUnitHealth() {
    return unitHealth;
  }

  void loadImageData()
  {
    String path = characterFolder + "/" + characterAction + "/";
    sprites = new PImage[totalSize];

    for (int i = 0; i < totalSize; i++)
    {
      String fileName = imageFileName + (i+1) + fileExtension;
      sprites[i] = loadImage(path + fileName);

      if (sprites[i] == null) {
        println("Missing image: " + path + fileName);
      }
    }
  }

  void render(float x, float y)
  {
    if (sprites == null) return;
    PImage frame = sprites[currentIndex];
    if (frame == null) return;

    imageMode(CENTER);
    image(frame, x, y, frame.width * spriteScale, frame.height * spriteScale);
  }

  void renderNext(float x, float y)
  {
    if (sprites == null || totalSize <= 0) return;
    if (currentIndex < 0) currentIndex = 0;
    if (currentIndex >= totalSize) currentIndex = totalSize - 1;

    if (sprites[currentIndex] != null) {
      render(x, y);
    } 

    if (!isStop) {
      currentIndex++;

      if (currentIndex >= totalSize) {
        if (isLoop) {
          currentIndex = 0;
        } else {
          currentIndex = totalSize - 1;
          finished = true;
          isStop = true;
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
  }
}
