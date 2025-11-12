enum AnimationState 
{
  IDLE,
  TEASER
}

class Unit 
{
  int currentHealth;
  int maxHealth;

  float portraitX, portraitY; 
  PImage portraitImage;       
  float portraitScale = 1.0; 
  
  Sprite idleSprite;
  Sprite teaserSprite;
  AnimationState currentState;
  
  ArrayList<String> taunts;
  String currentTaunt;
  String unitName;

  Unit(float px, float py, String name) 
  {
    this.unitName = name;
    this.portraitX = px;
    this.portraitY = py;
    
    this.taunts = new ArrayList<String>();
    this.currentTaunt = "";
    this.currentState = AnimationState.IDLE;
    
    idleSprite = new Sprite(name + "_idle.txt");
    teaserSprite = new Sprite(name + "_teaser.txt");
    
    this.maxHealth = idleSprite.getUnitHealth();
    this.currentHealth = this.maxHealth;
    
    idleSprite.isLoop = true;
    teaserSprite.isLoop = false; 
    
    idleSprite.play();
  }
  
  void loadSpriteImages() {
    portraitImage = loadImage(unitName + "/portrait.png");
    
    idleSprite.loadImageData();
    teaserSprite.loadImageData();
  }

  void addTaunt(String taunt) {
    taunts.add(taunt);
  }
  
  void playTeaser() {
    currentState = AnimationState.TEASER;
    
    idleSprite.stop();
    teaserSprite.reset();
    teaserSprite.play();
    
    if (taunts.size() > 0) {
      int tauntIndex = int(random(taunts.size()));
      currentTaunt = taunts.get(tauntIndex);
    } else {
      currentTaunt = "I have no taunts!";
    }
  }

  void stopTeaser() {
    currentState = AnimationState.IDLE;
    currentTaunt = "";
    
    teaserSprite.stop();
    idleSprite.reset();
    idleSprite.play();
  }

  void update() {
    if (currentState == AnimationState.TEASER) {
      if (teaserSprite.isFinished()) {
        stopTeaser();
      }
    }
  }

  boolean isMouseOverPortrait(int mx, int my) {
    if (portraitImage == null) return false;
    
    float w = (portraitImage.width * portraitScale) / 2;
    float h = (portraitImage.height * portraitScale) / 2;
    
    return (mx >= portraitX - w && mx <= portraitX + w &&
            my >= portraitY - h && my <= portraitY + h);
  }

  void drawPortrait() {
    if (portraitImage == null) return;
    
    float w = portraitImage.width * portraitScale;
    float h = portraitImage.height * portraitScale;
    
    imageMode(CENTER);
    image(portraitImage, portraitX, portraitY, w, h);
  }

  void drawAnimation(float x, float y) {
    if (currentState == AnimationState.TEASER) {
      teaserSprite.renderNext(x, y);
    } else {
      idleSprite.renderNext(x, y);
    }
  }

  void drawTaunt(float animX, float animY) {
    if (currentTaunt == null || currentTaunt.isEmpty()) {
      return; 
    }
    
    if (currentState == AnimationState.TEASER) {
      fill(255);
      textSize(16);
      textAlign(CENTER, BOTTOM);
      text(currentTaunt, animX, animY - 100);
    }
  }
}
