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
  
  // Initialize the main logic controller
  characterBrowser = new CharacterBrowser();
  
  // (In a real app, you would load assets here and pass them to the browser)
}

void draw() {
  // Clear the screen every frame
  background(50); // Dark grey background
  
  // Tell the character browser to update its logic and render everything
  characterBrowser.render();
}

void mousePressed() {
  // Pass the mouse click event to the logic handler
  // It will determine what to do based on the button (LEFT or RIGHT)
  characterBrowser.handleMouseClick(mouseX, mouseY, mouseButton);
}
