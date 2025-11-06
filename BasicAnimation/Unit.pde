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
  
  // --- Animation Properties ---
  AnimationState currentState;
  int teaserStartTime;
  int teaserDuration = 3000; // Teaser animation plays for 3 seconds
  
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
    teaserStartTime = millis(); // Get the current time
    
    if (taunts.size() > 0) {
      int tauntIndex = int(random(taunts.size()));
      currentTaunt = taunts.get(tauntIndex);
    } else {
      currentTaunt = "I have no taunts!";
    }
  }

  // --- NEW FUNCTION ---
  /**
   * Immediately stops the teaser animation and clears the taunt.
   */
  void stopTeaser() {
    currentState = AnimationState.IDLE;
    currentTaunt = "";
  }

  /**
   * Called every frame by the logic class.
   */
  void update() {
    if (currentState == AnimationState.TEASER) {
      if (millis() - teaserStartTime > teaserDuration) {
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
    if (currentState == AnimationState.TEASER) {
      fill(255, 200, 0); // Yellow
      circle(x, y, 150);
      fill(0);
      textAlign(CENTER, CENTER);
      text("TEASER ANIMATION", x, y);
      
    } else { // IDLE state
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
  void drawTaunt(float animX, float animY) {
    if (currentTaunt == null || currentTaunt.isEmpty()) {
      return; 
    }
    
    // Only draw the generic taunt IF we are in the teaser state.
    if (currentState == AnimationState.TEASER) {
      fill(255); // White color
      textSize(16);
      textAlign(CENTER, BOTTOM);
      text(currentTaunt, animX, animY - 100);
    }
  }
}
