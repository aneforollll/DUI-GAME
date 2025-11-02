// --- Character Selection Example ---

// Variables to hold character data
PImage knight, wizard;
String selectedCharacter = ""; // stores which character is chosen

// Button areas
int knightX = 150, knightY = 200;
int wizardX = 450, wizardY = 200;
int charSize = 150;

boolean gameStarted = false; // flag to move to next screen

void setup() {
  size(800, 600);
  
  // Load your character images
  // (replace these with your own image files in the 'data' folder)
  knight = loadImage("knight.png");
  wizard = loadImage("wizard.png");
}

void draw() {
  background(40, 50, 70);

  if (!gameStarted) {
    showCharacterSelection();
  } else {
    startGame();
  }
}

void showCharacterSelection() {
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Choose Your Character", width/2, 80);

  // Draw Knight
  image(knight, knightX, knightY, charSize, charSize);
  fill(200);
  text("Knight", knightX + charSize/2, knightY + charSize + 30);

  // Draw Wizard
  image(wizard, wizardX, wizardY, charSize, charSize);
  fill(200);
  text("Wizard", wizardX + charSize/2, wizardY + charSize + 30);

  // Highlight selection
  noFill();
  stroke(255, 255, 0);
  strokeWeight(4);
  if (selectedCharacter.equals("Knight")) {
    rect(knightX - 5, knightY - 5, charSize + 10, charSize + 10);
  } else if (selectedCharacter.equals("Wizard")) {
    rect(wizardX - 5, wizardY - 5, charSize + 10, charSize + 10);
  }
}

void mousePressed() {
  // Check if knight was clicked
  if (mouseX > knightX && mouseX < knightX + charSize &&
      mouseY > knightY && mouseY < knightY + charSize) {
    selectedCharacter = "Knight";
  }

  // Check if wizard was clicked
  if (mouseX > wizardX && mouseX < wizardX + charSize &&
      mouseY > wizardY && mouseY < wizardY + charSize) {
    selectedCharacter = "Wizard";
  }

  // If a character is selected, go to next screen after click
  if (selectedCharacter != "") {
    delay(300);
    gameStarted = true;
  }
}

void startGame() {
  background(20, 100, 50);
  fill(255);
  textAlign(CENTER);
  textSize(28);
  text("You chose: " + selectedCharacter, width/2, height/2);
  text("Game Starting...", width/2, height/2 + 50);
}
