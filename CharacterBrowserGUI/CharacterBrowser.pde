/**
 * CharacterBrowser (Logic Class)
 * * This class handles the core logic of the character browser.
 * It now has a "Confirm" button to trigger special taunts.
 * Clicking a character only plays their generic taunt.
 */

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Arrays;

// --- A helper class to store the sequence ---
class TeamTaunt {
  String speaker1, taunt1;
  String speaker2, taunt2;
  
  TeamTaunt(String s1, String t1, String s2, String t2) {
    this.speaker1 = s1;
    this.taunt1 = t1;
    this.speaker2 = s2;
    this.taunt2 = t2;
  }
}

// --- State machine for the team taunt conversation ---
enum TeamTauntState {
  IDLE,              // Not checking (or not a full team)
  SPEAKER_1_DELAY,   // Pause before speaker 1
  SPEAKER_1_TALKING,
  SPEAKER_2_DELAY,   // Pause before speaker 2
  SPEAKER_2_TALKING,
  DONE               // Conversation finished
}


class CharacterBrowser 
{
  ArrayList<Unit> units;
  HashMap<String, Unit> unitMap;
  Unit mainCharacter;
  Unit partnerCharacter;
  
  boolean readyForBattle = false;
  boolean isLoading = true; // Flag to show loading screen
  PImage bgImage; // Variable for the background image
  
  // --- Team Taunt Variables ---
  HashMap<String, ArrayList<TeamTaunt>> teamTaunts;
  TeamTaunt currentTeamTaunt = null;
  TeamTauntState teamTauntState = TeamTauntState.IDLE;
  int teamTauntTimer = 0;
  
  // --- Timing for the conversation ---
  int delaySpeaker1 = 500;
  int durationSpeaker1 = 3000;
  int delaySpeaker2 = 300;
  int durationSpeaker2 = 3000;
  
  // --- NEW: Confirm Button Variables ---
  float confirmBtnX, confirmBtnY, confirmBtnW, confirmBtnH;
  
  
  // Constructor
  CharacterBrowser() 
  {
    units = new ArrayList<Unit>();
    unitMap = new HashMap<String, Unit>();
    teamTaunts = new HashMap<String, ArrayList<TeamTaunt>>(); 
    
    // --- NEW: Set up confirm button coordinates ---
    confirmBtnW = 150;
    confirmBtnH = 50;
    confirmBtnX = width - confirmBtnW - 40; // Top-right corner
    confirmBtnY = 40;
    
    loadUnits();
    loadTeamTaunts("specialTaunt.txt");
  }
  
  /**
   * Called by the main GUI thread to load all sprite images.
   */
  void loadAllSpriteImages() {
    println("--- Threaded image loading started... ---");
    
    bgImage = loadImage("background.png"); 
    
    for (Unit unit : units) {
      unit.loadSpriteImages();
    }
    println("--- Image loading finished. ---");
    isLoading = false;
  }
  
  /**
   * Populates the list of available units from genericTaunt.txt
   */
  void loadUnits() {
    String[] lines = loadStrings("genericTaunt.txt");
    if (lines == null || lines.length == 0) {
      println("Failed to load genericTaunt.txt.");
      return;
    }
    
    float currentX = 100;
    float currentY = 100;
    float padding = 30;
    float portraitSize = 120;
    
    for (String line : lines) {
      if (line == null || line.trim().isEmpty()){ continue; }
      String[] parts = line.split(": ");
      if (parts.length < 2){ continue; }
      
      String name = parts[0].trim();
      String genericTaunt = parts[1].trim();
      
      Unit unit = unitMap.get(name);
      if (unit == null) {
        unit = new Unit(currentX, currentY, name);
        unitMap.put(name, unit);
        units.add(unit);
        
        currentX += portraitSize + padding;
        if (currentX + portraitSize > width -100) {
          currentX = 100;
          currentY += portraitSize + padding;
        }
      }
      unit.addTaunt(genericTaunt);
    }
  }
  
  /**
   * Loads the new specialTaunt.txt format
   */
  void loadTeamTaunts(String filename) {
    String[] lines = loadStrings(filename);
    
    if (lines == null || lines.length == 0) {
      println("Warning: '" + filename + "' not found or is empty.");
      return;
    }
    
    for (String line : lines) {
      if (line == null || line.trim().isEmpty() || line.startsWith("#")) { continue; }
      
      String[] pairAndTaunt = line.split(":", 2);
      if (pairAndTaunt.length < 2) {
        println("Skipping malformed line: " + line);
        continue;
      }
      
      String pairPart = pairAndTaunt[0].trim();
      String tauntPart = pairAndTaunt[1].trim();
      
      String[] names = pairPart.split("/");
      if (names.length < 2) continue;
      Arrays.sort(names); 
      String key = names[0] + names[1];
      
      String[] tauntHalves = tauntPart.split("/");
      if (tauntHalves.length < 2) continue;
      
      String[] half1 = tauntHalves[0].trim().split(":", 2);
      String[] half2 = tauntHalves[1].trim().split(":", 2);
      
      if (half1.length < 2 || half2.length < 2) continue;
      
      String s1 = half1[0].trim();
      String t1 = half1[1].trim();
      String s2 = half2[0].trim();
      String t2 = half2[1].trim();
      
      TeamTaunt newTaunt = new TeamTaunt(s1, t1, s2, t2);
      
      if (!teamTaunts.containsKey(key)) {
        teamTaunts.put(key, new ArrayList<TeamTaunt>());
      }
      teamTaunts.get(key).add(newTaunt);
    }
  }
  
  /**
   * --- HEAVILY MODIFIED ---
   * Handles the input event from the main GUI.
   * Now checks for button clicks OR character clicks.
   */
  void handleMouseClick(int mx, int my, int button) 
  {
    if (isLoading) return; // Don't allow clicks while loading
    
    // --- NEW: Check for confirm button click first ---
    if (isMouseOverConfirmButton(mx, my)) {
      handleConfirmClick();
      return; // Stop processing the click
    }

    // --- This logic is now ONLY for character selection ---
    for (Unit unit : units) {
      if (unit.isMouseOverPortrait(mx, my)) {
        
        // --- NEW: Reset team taunt state on any new selection ---
        teamTauntState = TeamTauntState.IDLE;
        currentTeamTaunt = null;
        
        // Stop any currently playing special taunts
        if (mainCharacter != null) mainCharacter.stopTeaser();
        if (partnerCharacter != null) partnerCharacter.stopTeaser();

        
        if (button == LEFT) {
          if (unit == partnerCharacter) { return; } // No dupes
          mainCharacter = unit;
          unit.playTeaser(); // Play generic taunt
        } else if (button == RIGHT) {
          if (unit == mainCharacter) { return; } // No dupes
          partnerCharacter = unit;
          unit.playTeaser(); // Play generic taunt
        }
        return; 
      }
    }
  }

  /**
   * --- NEW FUNCTION ---
   * This logic is called when the "Confirm" button is clicked.
   */
  void handleConfirmClick() {
    // Only works if a full team is selected
    if (mainCharacter != null && partnerCharacter != null) {
      // Stop generic taunts
      mainCharacter.stopTeaser();
      partnerCharacter.stopTeaser();
      
      // Find and start the special taunt
      currentTeamTaunt = findTeamTaunt();
      
      if (currentTeamTaunt != null) {
        teamTauntState = TeamTauntState.SPEAKER_1_DELAY;
        teamTauntTimer = millis();
      } else {
        teamTauntState = TeamTauntState.DONE;
        currentTeamTaunt = null;
      }
    }
  }


  /**
   * The main render function.
   */
  void render() 
  {
    // Draw the background image first
    if (bgImage != null) {
      imageMode(CORNER); // Set imageMode for background
      image(bgImage, 0, 0, width, height);
    } else {
      background(50); // Fallback if image failed
    }
  
    for (Unit unit : units) { unit.update(); }
    for (Unit unit : units) { unit.drawPortrait(); }
    
    float mainAnimX = (width / 2) - 300;
    float partnerAnimX = ( width / 2) + 300;
    float animY = 450;
    
    if (mainCharacter != null) {
      mainCharacter.drawAnimation(mainAnimX, animY);
      mainCharacter.drawTaunt(mainAnimX, animY);
      drawCharacterName(mainCharacter, mainAnimX, animY);
    }
    
    if (partnerCharacter != null) {
      partnerCharacter.drawAnimation(partnerAnimX, animY);
      partnerCharacter.drawTaunt(partnerAnimX, animY);
      drawCharacterName(partnerCharacter, partnerAnimX, animY);
    }
    
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text("MAIN", mainAnimX, 300);
    text("PARTNER", partnerAnimX, 300);
    text("Select a Unit", width / 2, 50);
    textSize(12);
    text("Left-Click: Set Main  |  Right-Click: Set Partner", width / 2, 80);
    
    drawSelectionBox();
    drawConfirmButton(); // <-- NEW: Draw the button
    
    updateTeamTauntState();
    drawTeamTaunt(mainAnimX, partnerAnimX, animY);
  }

  /**
   * This is the core logic for the conversation.
   */
 void updateTeamTauntState() {
  switch (teamTauntState) {
    case SPEAKER_1_DELAY:
      if (millis() - teamTauntTimer > delaySpeaker1) {
        teamTauntState = TeamTauntState.SPEAKER_1_TALKING;
        teamTauntTimer = millis();
      }
      break;
    case SPEAKER_1_TALKING:
      if (millis() - teamTauntTimer > durationSpeaker1) {
        teamTauntState = TeamTauntState.SPEAKER_2_DELAY;
        teamTauntTimer = millis();
      }
      break;
    case SPEAKER_2_DELAY:
      if (millis() - teamTauntTimer > delaySpeaker2) {
        teamTauntState = TeamTauntState.SPEAKER_2_TALKING;
        teamTauntTimer = millis();
      }
      break;
    case SPEAKER_2_TALKING:
      if (millis() - teamTauntTimer > durationSpeaker2) {
        teamTauntState = TeamTauntState.DONE;
        currentTeamTaunt = null;

        // --- NEW: Mark ready for battle after taunt ends ---
        readyForBattle = true;
      }
      break;
    case IDLE:
    case DONE:
      break;
  }
}


  /**
   * Draws the current part of the conversation
   */
  void drawTeamTaunt(float mainX, float partnerX, float y) {
    if (currentTeamTaunt == null) {
      return;
    }

    if (teamTauntState == TeamTauntState.SPEAKER_1_TALKING) {
      drawTauntOverCharacter(
        currentTeamTaunt.speaker1, 
        currentTeamTaunt.taunt1, 
        mainX, partnerX, y);
    }
    else if (teamTauntState == TeamTauntState.SPEAKER_2_TALKING) {
      drawTauntOverCharacter(
        currentTeamTaunt.speaker2, 
        currentTeamTaunt.taunt2, 
        mainX, partnerX, y);
    }
  }
  
  /**
   * Helper to draw text over the correct character
   */
  void drawTauntOverCharacter(String speakerName, String text, float mainX, float partnerX, float y) {
    float xPos = 0;
    
    if (mainCharacter != null && mainCharacter.unitName.equals(speakerName)) {
      xPos = mainX;
    } else if (partnerCharacter != null && partnerCharacter.unitName.equals(speakerName)) {
      xPos = partnerX;
    } else {
      println("Error: Could not find speaker: " + speakerName);
      return; 
    }
    
    fill(255); // White color
    textSize(18);
    textAlign(CENTER, BOTTOM);
    text(text, xPos, y - 100);
  }

  /**
   * Finds a random team taunt for the currently selected pair.
   */
  TeamTaunt findTeamTaunt() {
    if (mainCharacter == null || partnerCharacter == null) {
      return null;
    }
    String[] names = { mainCharacter.unitName, partnerCharacter.unitName };
    Arrays.sort(names);
    String key = names[0] + names[1];
    
    ArrayList<TeamTaunt> tauntList = teamTaunts.get(key);
    
    if (tauntList != null && !tauntList.isEmpty()) {
      int randomIndex = int(random(tauntList.size()));
      return tauntList.get(randomIndex);
    }
    return null; // No taunt found
  }

  // --- Utility functions for drawing GUI ---

  void drawCharacterName (Unit unit, float x, float y)
  {
    fill(255);
    textSize(22);
    textAlign(CENTER, TOP);
    text(unit.unitName, x, y + 100);
  }
  
  /**
   * --- NEW: Draws the "Confirm" button ---
   */
  void drawConfirmButton() {
    rectMode(CORNER);
    
    // Check if button is active
    if (mainCharacter != null && partnerCharacter != null) {
      fill(0, 200, 0, 200); // Green, active
      stroke(255);
    } else {
      fill(100, 100, 100, 150); // Greyed out, inactive
      stroke(180);
    }
    
    rect(confirmBtnX, confirmBtnY, confirmBtnW, confirmBtnH, 10); // Rounded corners
    
    // Draw text on button
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("CONFIRM", confirmBtnX + confirmBtnW / 2, confirmBtnY + confirmBtnH / 2);
  }

  /**
   * --- NEW: Checks if mouse is over the "Confirm" button ---
   */
  boolean isMouseOverConfirmButton(float mx, float my) {
    return (mx >= confirmBtnX && mx <= confirmBtnX + confirmBtnW &&
            my >= confirmBtnY && my <= confirmBtnY + confirmBtnH);
  }
  
  void drawSelectionBox() {
    float boxY = height - 120;
    float boxHeight = 120;
    float portraitSize = 100;
    
    // Background is now transparent (as requested)
    //noStroke();
    //fill(20, 20, 20, 200);
    //rect(0, boxY, width, boxHeight);
    
    float mainBoxX = (width / 2) - 130;
    float partnerBoxX = (width / 2) + 30;
    
    fill(255);
    textSize(16);
    textAlign(CENTER);
    text("MAIN", mainBoxX + portraitSize / 2, boxY + 15);
    
    stroke(100);
    fill(40, 200); // Made fill semi-transparent
    rectMode(CORNER);
    rect(mainBoxX, boxY + 25, portraitSize, portraitSize - 10);
    
    if (mainCharacter != null) {
      drawUnitInBox(mainCharacter, mainBoxX, boxY + 25, portraitSize - 10);
    }
    
    fill(255);
    textSize(16);
    textAlign(CENTER);
    text("PARTNER", partnerBoxX + portraitSize / 2, boxY + 15);

    stroke(100);
    fill(40, 200); // Made fill semi-transparent
    rectMode(CORNER);
    rect(partnerBoxX, boxY + 25, portraitSize, portraitSize - 10);
    
    if (partnerCharacter != null) {
      drawUnitInBox(partnerCharacter, partnerBoxX, boxY + 25, portraitSize - 10);
    }
  }
  
  void drawUnitInBox(Unit unit, float x, float y, float size) {
    if (unit != null && unit.portraitImage != null) {
      imageMode(CENTER);
      image(unit.portraitImage, x + size/2, y + size/2, size, size);
    }
  }
}
