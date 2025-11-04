/**
 * Unit (Data Class)
 * * Represents a single character. This class manages its own
 * state (idle, teaser), animation timing, portrait,
 * and taunt message.
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
  float portraitX, portraitY;
  float portraitWidth, portraitHeight;
  // PImage portraitImage; // (Uncomment to use a real image)
  
  // --- Animation Properties ---
  // (In a real app, these would be PImage[] arrays for animation frames)
  AnimationState currentState;
  int teaserStartTime;
  int teaserDuration = 2000; // Teaser animation plays for 2 seconds
  
  // --- Unit Data ---
  ArrayList<String> taunts;
  String currentTaunt;
  String unitName;

  // Constructor
  Unit(float px, float py, String name) 
  {
    this.portraitX = px;
    this.portraitY = py;
    this.portraitWidth = 120;
    this.portraitHeight = 120;
    
    this.unitName = name;
    
    this.taunts = new ArrayList<String>();
    this.currentTaunt = "";
    
    this.currentState = AnimationState.IDLE;
    // this.portraitImage = loadImage("path/to/" + name + "_portrait.png");
    // (Load animation frames here)
  }
  
  void addTaunt(String taunt)
  {
    taunts.add(taunt);
  }
  
  /**
   * Called by the logic class to start the teaser animation.
   */
  void playTeaser() 
  {
    currentState = AnimationState.TEASER;
    teaserStartTime = millis(); // Get the current time
    
    if (taunts.size() > 0)
    {
      int tauntIndex = int(random(taunts.size()));
      currentTaunt = taunts.get(tauntIndex);
    }
    else
    {
      currentTaunt = "I speak no such thing.";
    }
  }

  /**
   * Called every frame by the logic class.
   * This handles internal state logic, like animation timing.
   */
  void update() {
    // If we are playing the teaser animation...
    if (currentState == AnimationState.TEASER) {
      // ...check if enough time has passed.
      if (millis() - teaserStartTime > teaserDuration) {
        // If so, switch back to the idle animation.
        currentState = AnimationState.IDLE;
      }
    }
  }

  /**
   * Checks if a mouse click is over this unit's portrait.
   */
  boolean isMouseOverPortrait(int mx, int my) {
    return (mx >= portraitX && mx <= portraitX + portraitWidth &&
            my >= portraitY && my <= portraitY + portraitHeight);
  }

  /**
   * Draws the unit's portrait in the selection grid.
   */
  void drawPortrait() {
    // (In a real app: image(portraitImage, portraitX, portraitY);)
    
    // Skeleton placeholder:
    stroke(255);
    fill(100);
    rect(portraitX, portraitY, portraitWidth, portraitHeight);
    
    fill(255);
    textAlign(CENTER, CENTER);
    text(unitName, portraitX + portraitWidth / 2, portraitY + portraitHeight / 2);
  }

  /**
   * Draws the unit's main animation at a specific screen location.
   */
  void drawAnimation(float x, float y) {
    // This function draws the unit's animation based on its current state.
    
    // (In a real app, you would draw different animation frames here)
    
    // Skeleton placeholder:
    if (currentState == AnimationState.TEASER) {
      // Draw a "teaser" placeholder
      fill(255, 200, 0); // Yellow
      circle(x, y, 150);
      fill(0);
      textAlign(CENTER, CENTER);
      text("TEASER ANIMATION", x, y);
      
    } else { // IDLE state
      // Draw an "idle" placeholder
      fill(0, 150, 255); // Blue
      circle(x, y, 120);
      fill(255);
      textAlign(CENTER, CENTER);
      text("IDLE ANIMATION", x, y);
    }
  }

  /**
   * Draws the unit's taunt message above its animation.
   */
  void drawTaunt(float animX, float animY) 
  {
    if (currentTaunt == null || currentTaunt.isEmpty()) {return;}
    
    fill(255);
    textSize(16);
    textAlign(CENTER, BOTTOM);
    // Draw text above the animation (e.g., above the circle's top)
    text(currentTaunt, animX, animY - 100);
  }
}
