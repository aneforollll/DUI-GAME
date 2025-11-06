/**
 * Unit (Data Class)
 * * Represents a single character. This class now manages
 * Sprites for animations and a single PImage for the portrait.
 */

// An enumeration to track the unit's animation state
enum AnimationState 
{
  IDLE,
  TEASER
}

class Unit 
{
  // --- Portrait Properties ---
  float portraitX, portraitY; // Position of the portrait
  PImage portraitImage;     // <-- Static portrait image
  float portraitScale = 1.0; // <-- Scale for the portrait
  
  // --- Animation Properties ---
  Sprite idleSprite;
  Sprite teaserSprite;
  AnimationState currentState;
  
  // --- Unit Data ---
  ArrayList<String> taunts;
  String currentTaunt;
  String unitName;

  // Constructor
  Unit(float px, float py, String name) 
  {
    this.unitName = name;
    this.portraitX = px; // Store the portrait's position
    this.portraitY = py;
    
    this.taunts = new ArrayList<String>();
    this.currentTaunt = "";
    this.currentState = AnimationState.IDLE;
    
    // Create sprites (but don't load images yet)
    idleSprite = new Sprite(name + "_idle.txt");
    teaserSprite = new Sprite(name + "_teaser.txt");
    
    // Set looping properties
    idleSprite.isLoop = true;
    teaserSprite.isLoop = false; // Teaser plays once
    
    // Start idle animation by default
    idleSprite.play();
  }
  
  /**
   * Loads the actual image data for all sprites.
   * This MUST be called from the main setup().
   */
  void loadSpriteImages() {
    // Load the static portrait from "data/[charactername]/portrait.png"
    portraitImage = loadImage(unitName + "/portrait.png");
    
    // Load the animation sprites
    idleSprite.loadImageData();
    teaserSprite.loadImageData();
  }

  /**
   * Adds a taunt to this unit's list of possible taunts.
   */
  void addTaunt(String taunt) {
    taunts.add(taunt);
  }
  
  /**
   * Called by the logic class to start the teaser animation.
   */
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

  /**
   * Immediately stops the teaser animation and clears the taunt.
   */
  void stopTeaser() {
    currentState = AnimationState.IDLE;
    currentTaunt = "";
    
    teaserSprite.stop();
    idleSprite.reset();
    idleSprite.play();
  }

  /**
   * Called every frame by the logic class.
   * Checks if the teaser animation is finished.
   */
  void update() {
    if (currentState == AnimationState.TEASER) {
      if (teaserSprite.isFinished()) {
        stopTeaser();
      }
    }
  }

  /**
   * Checks if a mouse click is over this unit's portrait.
   */
  boolean isMouseOverPortrait(int mx, int my) {
    if (portraitImage == null) return false;
    
    float w = (portraitImage.width * portraitScale) / 2;
    float h = (portraitImage.height * portraitScale) / 2;
    
    return (mx >= portraitX - w && mx <= portraitX + w &&
            my >= portraitY - h && my <= portraitY + h);
  }

  /**
   * Draws the unit's static portrait in the selection grid.
   */
  void drawPortrait() {
    if (portraitImage == null) return;
    
    imageMode(CENTER);
    image(portraitImage, portraitX, portraitY, 
          portraitImage.width * portraitScale, 
          portraitImage.height * portraitScale);
  }

  /**
   * Draws the unit's main animation at a specific screen location.
   */
  void drawAnimation(float x, float y) {
    if (currentState == AnimationState.TEASER) {
      teaserSprite.renderNext(x, y);
    } else {
      idleSprite.renderNext(x, y);
    }
  }

  /**
   * Draws the unit's taunt message above its animation.
   */
  void drawTaunt(float animX, float animY) {
    if (currentTaunt == null || currentTaunt.isEmpty()) {
      return; 
    }
    
    if (currentState == AnimationState.TEASER) {
      fill(255); // White color
      textSize(16);
      textAlign(CENTER, BOTTOM);
      text(currentTaunt, animX, animY - 100);
    }
  }
}
