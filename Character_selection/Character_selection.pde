// --- Character Selection (Pick 2 to Start) ---

PImage knight, wizard, archer; // add as many characters as you like
String[] selected = new String[2]; // store up to 2 chosen characters
boolean gameStarted = false;

// Character button positions
int charSize = 150;
int gap = 200;

CharacterButton[] buttons;

void setup() {
  size(800, 600);
  
  // Load character images from /data folder
  knight = loadImage("knight.jpg");
  wizard = loadImage("wizard.jpg");
  archer = loadImage("archer.jpg ");
  
  // Create character buttons
  buttons = new CharacterButton[3];
  buttons[0] = new CharacterButton("Knight", knight, 150, 200);
  buttons[1] = new CharacterButton("Wizard", wizard, 350, 200);
  buttons[2] = new CharacterButton("Archer", archer, 550, 200);
}

void draw() {
  background(40, 50, 70);
  
  if (!gameStarted) {
    showSelectionScreen();
  } else {
    startGame();
  }
}

void showSelectionScreen() {
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Select 2 Characters", width/2, 80);
  
  // Draw buttons
  for (CharacterButton b : buttons) {
    b.display();
  }
  
  // Show selected list
  textSize(20);
  textAlign(LEFT);
  fill(255);
  text("Selected: " + join(selected, ", "), 50, 500);
  
  // If two characters chosen, show start button
  if (selected[0] != null && selected[1] != null) {
    fill(0, 200, 0);
    rect(width/2 - 75, 520, 150, 50, 10);
    fill(255);
    textAlign(CENTER);
    text("Start Game", width/2, 552);
  }
}

void mousePressed() {
  if (!gameStarted) {
    // Check if a character button was clicked
    for (CharacterButton b : buttons) {
      if (b.isClicked(mouseX, mouseY)) {
        selectCharacter(b.name);
      }
    }
    
    // Start button pressed
    if (selected[0] != null && selected[1] != null) {
      if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
          mouseY > 520 && mouseY < 570) {
        gameStarted = true;
      }
    }
  }
}

void selectCharacter(String name) {
  // Prevent duplicates
  if ((selected[0] != null && selected[0].equals(name)) || 
      (selected[1] != null && selected[1].equals(name))) {
    // Deselect if clicked again
    if (selected[0] != null && selected[0].equals(name)) selected[0] = null;
    if (selected[1] != null && selected[1].equals(name)) selected[1] = null;
    cleanArray();
    return;
  }
  
  // Add to selection
  if (selected[0] == null) {
    selected[0] = name;
  } else if (selected[1] == null) {
    selected[1] = name;
  }
}

// Simple method to compact array after deselection
void cleanArray() {
  if (selected[0] == null && selected[1] != null) {
    selected[0] = selected[1];
    selected[1] = null;
  }
}

void startGame() {
  background(20, 120, 60);
  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("Game Starting!", width/2, 100);
  text("Team: " + selected[0] + " & " + selected[1], width/2, 180);
}

// --- Helper class for character buttons ---
class CharacterButton {
  String name;
  PImage img;
  int x, y;
  boolean char_selected = false;
  
  CharacterButton(String n, PImage i, int x, int y) {
    name = n;
    img = i;
    this.x = x;
    this.y = y;
  }
  
  void display() {
    image(img, x, y, charSize, charSize);
    fill(200);
    textAlign(CENTER);
    text(name, x + charSize/2, y + charSize + 25);
    
    // Highlight if selected
    if (name.equals(selected[0]) || name.equals(selected[1])) {
      noFill();
      stroke(255, 255, 0);
      strokeWeight(4);
      rect(x - 5, y - 5, charSize + 10, charSize + 10);
    }
  }
  
  boolean isClicked(int mx, int my) {
    return mx > x && mx < x + charSize && my > y && my < y + charSize;
  }
}
