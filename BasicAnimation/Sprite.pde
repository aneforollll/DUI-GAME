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
  int x;
  int y;
  boolean isStop;
  boolean isLoop;
  
  public Sprite(String configFileName)
  {
    loadConfig(configFileName);
    currentIndex = 0;  // ✅ Start at first frame
    isStop = false;
    isLoop = true;
  }

  void loadConfig(String configFileName)
  {
    String[] configLine = loadStrings(configFileName);
    String[] configParameters = split(configLine[0], ' ');
    
    characterFolder = configParameters[0];
    characterAction = configParameters[1];
    imageFileName = configParameters[2];
    fileExtension = configParameters[3];
    totalSize = int(configParameters[4]);
    x = int(configParameters[5]);
    y = int(configParameters[6]);
    spriteScale = int(configParameters[7]);

    // ✅ If your config will include scale later, uncomment:
    
  }

  void loadImageData()
  {
    String path = characterFolder + "/" + characterAction + "/";
    
    sprites = new PImage[totalSize];
    
    for(int i = 0; i < totalSize; i++)
    {
      String fileName = imageFileName + (i+1) + fileExtension;
      println("Loading: " + path + fileName);
      sprites[i] = loadImage(path + fileName);
    }
  }

  void render()
  {
    imageMode(CENTER);
    image(sprites[currentIndex], x, y, 
      sprites[currentIndex].width * spriteScale, 
      sprites[currentIndex].height * spriteScale);
  }

  void renderNext()
  {
    if(!isStop)
    {
      currentIndex = (currentIndex + 1) % totalSize; // ✅ Safe wrap-around
    }

    render();
  }
  void play()
  {
     if(isLoop)
     {
       renderNext();
     }else{
       if(currentIndex == sprites.length-1)
       {
         render();
       }else{
         renderNext();
       }
  }
  }
  
}
