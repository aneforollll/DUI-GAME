/**
 * CharacterBrowserGUI (Main Tab)
 * * This is the main PApplet class. It handles the main setup, draw loop,
 * and user input events (like mouse clicks).
 * It delegates all the logic and rendering to the CharacterBrowser class.
 */

// The main logic handler for our character browser
CharacterBrowser characterBrowser;

void setup() {
  size(1280, 720);
<<<<<<< Updated upstream
  
=======
  frameRate(8);
>>>>>>> Stashed changes
  // Initialize the main logic controller
  characterBrowser = new CharacterBrowser();
  
  // --- MODIFIED ---
  // Instead of loading images here, we start a new thread
  // to load them in the background. This prevents the "Not Responding" error.
<<<<<<< Updated upstream
=======
  delay(200);
>>>>>>> Stashed changes
  thread("loadAllSpriteImages_Threaded");
}

void draw() {
  // Clear the screen every frame
  background(50); // Dark grey background
  
  // --- MODIFIED ---
  // Check if the characterBrowser is still loading images
  if (characterBrowser.isLoading) {
    // If loading, show a loading screen
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Loading Sprites...", width/2, height/2);
  } else {
    // If done, run the app normally
    characterBrowser.render();
  }
}

void mousePressed() {
  // Pass the mouse click event to the logic handler
  characterBrowser.handleMouseClick(mouseX, mouseY, mouseButton);
}

/**
 * --- NEW FUNCTION ---
 * This function is automatically called by thread("loadAllSpriteImages_Threaded")
 * It runs on a separate, background thread.
 */
void loadAllSpriteImages_Threaded() {
  characterBrowser.loadAllSpriteImages();
}
