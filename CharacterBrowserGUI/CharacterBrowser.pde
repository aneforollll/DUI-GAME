/**
 * CharacterBrowser (Logic Class)
 * * This class handles the core logic of the character browser.
 * It manages the list of all available units, tracks the selected
 * main and partner characters, and contains the main render()
 * function to draw the content.
 */

import java.util.ArrayList;

class CharacterBrowser 
{
  
  // A list to hold all available character units
  ArrayList<Unit> units;
  
  //A map to quickly find a unit by name
  HashMap<String, Unit> unitMap;
  
  // Variables to store the currently selected characters
  Unit mainCharacter;
  Unit partnerCharacter;
  
  // Constructor
  CharacterBrowser() 
  {
    units = new ArrayList<Unit>();
    unitMap = new HashMap<String, Unit>();
    loadUnits(); //populate the unit list
  }
  
  /**
   * Populates the list of available units.
   * (This is a stub - in a real app, you'd load this from a file)
   */
  void loadUnits() {
    String[] lines = loadStrings("genericTaunt.txt");
    
    if (lines == null || lines.length == 0)
    {
      println("Failed to load file.");
      return;
    }
    
    float currentX = 100;
    float currentY = 100;
    float padding = 30;
    float portraitSize = 120;
    
    for (String line : lines)
    {
      if (line == null || line.trim().isEmpty())
      {
        continue;
      }
      
      String[] parts = line.split(": ");
      if (parts.length < 2)
      {
        println("Skipping malformed line: " + line);
        continue;
      }
      
      String name = parts[0].trim();
      String genericTaunt = parts[1].trim();
      
      Unit unit = unitMap.get(name);
      if (unit == null)
      {
        unit = new Unit(currentX, currentY, name);
        unitMap.put(name, unit);
        
        units.add(unit);
        
        currentX += portraitSize + padding;
        if (currentX + portraitSize > width -100)
        {
          currentX = 100;
          currentY += portraitSize + padding;
        }
      }
      
      unit.addTaunt(genericTaunt);
      
    }
  }
  
  /**
   * Handles the input event from the main GUI.
   */
  void handleMouseClick(int mx, int my, int button) 
  {
    // Check if the click was on any unit's portrait
    for (Unit unit : units) 
    {
      if (unit.isMouseOverPortrait(mx, my)) 
      {
        
        if (button == LEFT) 
        {
          mainCharacter = unit;
          mainCharacter.playTeaser(); // Tell the unit to play its animation
        } 
        else if (button == RIGHT) 
        {
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
  void render() 
  {
    // --- 1. Update All Units ---
    // All units update their internal state (e.g., animation timers)
    for (Unit unit : units) 
    {
      unit.update();
    }
    
    // --- 2. Draw Unit Portraits ---
    // Draw the "selection grid" of portraits
    for (Unit unit : units) 
    {
      unit.drawPortrait();
    }
    
    // --- 3. Draw Selected Characters ---
    
    //center
    float mainAnimX = (width / 2) - 300;
    float partnerAnimX = ( width / 2) + 300;
    float animY = 450;
    
    // Draw the main character's animation
    if (mainCharacter != null) 
    {
      // Draw the animation at a specific "main" location
      mainCharacter.drawAnimation(mainAnimX, 450);
      mainCharacter.drawTaunt(mainAnimX, 450);
      drawCharacterName(mainCharacter, mainAnimX, animY);
    }
    
    // Draw the partner character's animation
    if (partnerCharacter != null) 
    {
      // Draw the animation at a specific "partner" location
      partnerCharacter.drawAnimation(partnerAnimX, 450);
      
      // Draw the taunt message
      partnerCharacter.drawTaunt(partnerAnimX, 450);
      
      drawCharacterName(partnerCharacter, partnerAnimX, animY);
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
  
  void drawCharacterName (Unit unit, float x, float y)
  {
    fill(255);
    textSize(22);
    textAlign(CENTER, TOP);
    text(unit.unitName, x, y + 100);
  }
  
  void drawSelectionBox()
  {
    float boxY = height - 120;
    float boxHeight = 120;
    float portraitSize = 100;
    
    //main bar
    noStroke();
    fill(20, 20, 20, 200);
    rect(0, boxY, width, boxHeight);
    
    float mainBoxX = (width / 2) - 100;
    float partnerBoxX = (width / 2) + 30;
    
    //main slot
    fill(255);
    textSize(16);
    textAlign(CENTER);
    text("MAIN", mainBoxX + portraitSize / 2, boxY + 15);
    
    stroke(100);
    fill(40);
    rect(mainBoxX, boxY + 25, portraitSize, portraitSize - 10);
    
    if (mainCharacter != null) 
    {
      drawUnitInBox(mainCharacter, mainBoxX, boxY + 25, portraitSize - 10);
    }
    
    // --- Draw PARTNER Slot ---
    fill(255);
    textSize(16);
    textAlign(CENTER);
    text("PARTNER", partnerBoxX + portraitSize / 2, boxY + 15);

    stroke(100);
    fill(40);
    rect(partnerBoxX, boxY + 25, portraitSize, portraitSize - 10);
    
    if (partnerCharacter != null) {
      drawUnitInBox(partnerCharacter, partnerBoxX, boxY + 25, portraitSize - 10);
    }
  }
 
  void drawUnitInBox(Unit unit, float x, float y, float size) 
  {
    stroke(255);
    fill(100);
    rect(x, y, size, size); // Draw the box
    
    fill(255);
    textAlign(CENTER, CENTER);
    if (unit.unitName.length() > 8) 
    {
      textSize(12);
    } else 
    {
      textSize(14);
    }
    text(unit.unitName, x + size / 2, y + size / 2);
  }

}
