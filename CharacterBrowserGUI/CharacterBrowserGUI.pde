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
  
  frameRate(30); // <-- CHANGED: Increased for smoother animation
  
  // Initialize the main logic controller
  characterBrowser = new CharacterBrowser();
  
  // --- MODIFIED ---
  // delay(200); // <-- REMOVED: This delay is not needed and can freeze the app
  thread("loadAllSpriteImages_Threaded");
}

void draw() {
  // Check if the characterBrowser is still loading images
  if (characterBrowser.isLoading) {
    // If loading, show a dark background and loading screen
    background(50); // <-- ADDED: Ensure loading screen has background
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
 * This function is automatically called by thread()
 * It runs on a separate, background thread.
 */
void loadAllSpriteImages_Threaded() {
  characterBrowser.loadAllSpriteImages();
}