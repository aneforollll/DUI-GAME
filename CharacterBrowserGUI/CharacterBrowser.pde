/**
 * CharacterBrowser (Logic Class)
 * * This class handles the core logic of the character browser.
 * It manages the list of all available units, tracks the selected
 * main and partner characters, and contains the main render()
 * function to draw the content.
 */

import java.util.ArrayList;

class CharacterBrowser {
  
  // A list to hold all available character units
  ArrayList<Unit> units;
  
  // Variables to store the currently selected characters
  Unit mainCharacter;
  Unit partnerCharacter;
  
  // Constructor
  CharacterBrowser() {
    units = new ArrayList<Unit>();
    loadUnits(); // Helper method to populate the unit list
  }
  
  /**
   * Populates the list of available units.
   * (This is a stub - in a real app, you'd load this from a file)
   */
  void loadUnits() {
    // Create a few dummy units for demonstration
    units.add(new Unit(100, 100, "You're too slow!", "Unit 1"));
    units.add(new Unit(250, 100, "Can't touch this!", "Unit 2"));
    units.add(new Unit(400, 100, "Is that all?", "Unit 3"));
    units.add(new Unit(550, 100, "My power is unmatched!", "Unit 4"));
  }
  
  /**
   * Handles the input event from the main GUI.
   */
  void handleMouseClick(int mx, int my, int button) {
    // Check if the click was on any unit's portrait
    for (Unit unit : units) {
      if (unit.isMouseOverPortrait(mx, my)) {
        
        if (button == LEFT) {
          mainCharacter = unit;
          mainCharacter.playTeaser(); // Tell the unit to play its animation
        } else if (button == RIGHT) {
          partnerCharacter = unit;
          partnerCharacter.playTeaser();
        }
        
        // Stop checking once we find a clicked unit
        return; 
      }
    }
  }

  /**
   * The main render function, called by the GUI's draw() loop.
   * This updates and draws all necessary content.
   */
  void render() {
    // --- 1. Update All Units ---
    // All units update their internal state (e.g., animation timers)
    for (Unit unit : units) {
      unit.update();
    }
    
    // --- 2. Draw Unit Portraits ---
    // Draw the "selection grid" of portraits
    for (Unit unit : units) {
      unit.drawPortrait();
    }
    
    // --- 3. Draw Selected Characters ---
    // Draw the main character's animation
    if (mainCharacter != null) {
      // Draw the animation at a specific "main" location
      mainCharacter.drawAnimation(200, 450);
      
      // Draw the taunt message
      mainCharacter.drawTaunt(200, 450);
    }
    
    // Draw the partner character's animation
    if (partnerCharacter != null) {
      // Draw the animation at a specific "partner" location
      partnerCharacter.drawAnimation(1080, 450);
      
      // Draw the taunt message
      partnerCharacter.drawTaunt(1080, 450);
    }
    
    // --- 4. Draw GUI Labels ---
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text("MAIN", 200, 300);
    text("PARTNER", 1080, 300);
    text("Select a Unit", width / 2, 50);
    textSize(12);
    text("Left-Click: Set Main  |  Right-Click: Set Partner", width / 2, 80);
  }
}
