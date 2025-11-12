class BattleScene {
  int teamHealth;
  int maxTeamHealth;
  float fade = 0;
  boolean fadeInDone = false;
  PImage bgImage;


  Unit mainCharacter;
  Unit partnerCharacter;
  Unit[] zombies;


  PVector mainPos, partnerPos;
  PVector[] zombiePos;
  

  float sliderX, sliderY, sliderW, sliderHandleX;
  boolean isDraggingSlider = false;

  BattleScene(Unit main, Unit partner) {
    this.mainCharacter = main;
    this.partnerCharacter = partner;
    

    this.maxTeamHealth = 0;
    if (mainCharacter != null) {
      this.maxTeamHealth += mainCharacter.maxHealth;
    }
    if (partnerCharacter != null) {
      this.maxTeamHealth += partnerCharacter.maxHealth;
    }
    this.teamHealth = this.maxTeamHealth; 


    mainPos = new PVector(width * 0.2, height * 0.6);
    partnerPos = new PVector(width * 0.35, height * 0.6);


    zombies = new Unit[3];
    zombiePos = new PVector[3];
    float startX = width * 0.65;
    float gap = 150;
    float zombieY = height * 0.65;

    for (int i = 0; i < 3; i++) {
      float x = startX + i * gap;
      zombiePos[i] = new PVector(x, zombieY);
      zombies[i] = new Unit(0, 0, "Zombie" + (i+1)); 
      zombies[i].loadSpriteImages();
    }


    mainCharacter.loadSpriteImages();
    partnerCharacter.loadSpriteImages();


    bgImage = loadImage("battle_bg.jpg"); 
    

    sliderX = 20;
    sliderY = 60; 
    sliderW = 300; 
    sliderHandleX = sliderX + sliderW; 
  }

  void render() {
   
    if (!fadeInDone) {
      fade += 10;
      if (fade >= 255) {
        fade = 255;
        fadeInDone = true;
      }
    }


    if (bgImage != null) {
      imageMode(CORNER);
      image(bgImage, 0, 0, width, height);
    } else {
      background(0);
    }


    for (int i = 0; i < zombies.length; i++) {
      if (zombies[i] == null) continue;
      drawUnit(zombies[i], zombiePos[i].x, zombiePos[i].y, false);
      drawEnemyHealthBar(zombies[i], zombiePos[i].x, zombiePos[i].y - 180);
    }


    if (mainCharacter != null) {
      drawUnit(mainCharacter, mainPos.x, mainPos.y, true);
    }
    if (partnerCharacter != null) {
      drawUnit(partnerCharacter, partnerPos.x, partnerPos.y, true);
    }
    

    this.teamHealth = 0;
    if (mainCharacter != null) {
      this.teamHealth += mainCharacter.currentHealth;
    }
    if (partnerCharacter != null) {
      this.teamHealth += partnerCharacter.currentHealth;
    }
    

    drawTeamHealthBar(); 
    drawDebugSlider();


    if (fade < 255) {
      fill(255, 255, 255, 255 - fade);
      rect(0, 0, width, height);
    }
  }


  void handleMouseClick(int mx, int my) {

    float handleRadius = 10;
    if (abs(mx - sliderHandleX) < handleRadius && abs(my - sliderY) < handleRadius) {
      isDraggingSlider = true;
    }
  }


  void handleMouseDrag(int mx, int my) {
    if (isDraggingSlider) {

      sliderHandleX = constrain(mx, sliderX, sliderX + sliderW);
      

      updateHealthFromSlider();
    }
  }
  

  void handleMouseRelease() {
    isDraggingSlider = false;
  }
  
 
  void updateHealthFromSlider() {

    float percent = (sliderHandleX - sliderX) / sliderW;
    

    if (mainCharacter != null) {
      mainCharacter.currentHealth = (int)(percent * mainCharacter.maxHealth);
    }

    if (partnerCharacter != null) {
      partnerCharacter.currentHealth = (int)(percent * partnerCharacter.maxHealth);
    }
  }


  void drawDebugSlider() {
    rectMode(CORNER);
    fill(80);
    noStroke();
    rect(sliderX, sliderY - 5, sliderW, 10, 5);
    

    if (isDraggingSlider) {
      fill(255);
    } else {
      fill(200); 
    }
    stroke(50);
    ellipse(sliderHandleX, sliderY, 20, 20);
  }
  
  void drawUnit(Unit unit, float x, float y, boolean facingRight) {
    if (unit == null) return;
    pushMatrix();
    translate(x, y);
    if (!facingRight) scale(-1, 1);
    unit.update();
    unit.drawAnimation(0, 0);
    unit.drawTaunt(0, 0);
    popMatrix();
  }

  void drawTeamHealthBar() {
    float barX = 20;
    float barY = 20;
    float barWidth = 300;
    float barHeight = 20;
    
    float healthPercent = 0;
    if (maxTeamHealth > 0) { 
      healthPercent = (float)teamHealth / maxTeamHealth;
    }
    healthPercent = constrain(healthPercent, 0, 1);
    
    rectMode(CORNER);
    noStroke();
    fill(50, 50, 50, 200); 
    rect(barX, barY, barWidth, barHeight, 5);
    
    fill(90, 220, 100); 
    rect(barX, barY, barWidth * healthPercent, barHeight, 5);
    
    fill(255);
    textSize(16);
    textAlign(LEFT, CENTER);
    text(teamHealth + " / " + maxTeamHealth, barX + barWidth + 10, barY + barHeight / 2);
  }

  void drawEnemyHealthBar(Unit enemy, float x, float y) {
    if (enemy == null) return;
    
    float barWidth = 100;
    float barHeight = 12;
    float barX = x - barWidth / 2;
    float barY = y; 
    
    float healthPercent = 0;
    if (enemy.maxHealth > 0) { 
      healthPercent = (float)enemy.currentHealth / enemy.maxHealth;
    }
    healthPercent = constrain(healthPercent, 0, 1);
    
    rectMode(CORNER);
    noStroke();
    fill(50, 50, 50, 200);
    rect(barX, barY, barWidth, barHeight, 3);
    
    fill(255, 80, 150); 
    rect(barX, barY, barWidth * healthPercent, barHeight, 3);
    
    fill(255);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(enemy.currentHealth, x, barY - 15);
  }
}
