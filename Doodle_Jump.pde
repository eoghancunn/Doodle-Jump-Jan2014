float ballY = 250;
float h = 20;
ArrayList<Block> blocks;
int initialNumbOfBlocks;
boolean collision;
float speedY = 1;
float fall_speed;
boolean paused;
PFont f;
int counter;
int spawnrate; 
int difficulty;
int score;
boolean restart = false;
int  moving_block_timer = 0;

void setup() {
  score = 0;
  difficulty = 0;
  counter = 0;
  spawnrate = 75;
  paused = false;
  f = createFont("Arial", 50, true);
  fall_speed = 1.5;
  initialNumbOfBlocks = 7;
  collision = false;
  size(500, 800);
  smooth();
  noStroke();
  blocks = new ArrayList<Block>(initialNumbOfBlocks);

  for (int i = 0; i < initialNumbOfBlocks; i++) {
    blocks.add(new Block(color(random(255), random(255), random(255)), random(500), (i * 800/initialNumbOfBlocks), fall_speed));
  }
  ellipseMode(CENTER);
}

void draw() {
  score++;
  counter++;
  if (paused == true) return;
  //clear the background and set the fill colour
  background(255);
  stroke(0);
  fill(0);
  fill(20, 255, 100);
  ellipse(mouseX, ballY, 20, 20);  
  ellipseMode(CENTER);
  fill(255);
  ellipse(mouseX + 5, ballY - 7, 9, 9);
  ellipse(mouseX - 5, ballY - 7, 9, 9);
  fill(0);   
  ellipse(mouseX + 5, ballY - 7, 3, 3);
  ellipse(mouseX - 5, ballY - 7, 3, 3); 
  
  //gravity
  speedY = speedY + 0.5; 
  ballY = ballY + speedY;

  // bounce
  if (collision == true) {
    speedY = -12;
    collision = false;
  }
  
  // increase difficulty
  if (difficulty == 10) {
    spawnrate = spawnrate + 15;
    counter = 0;
    difficulty = 0;
  }

  //spawn cars
  for (int i = 0; i < blocks.size(); i++) {
    Block block = blocks.get(i);
    block.drive();
    block.display();
  }
  if (counter == spawnrate) {
    blocks.add(new Block(color(random(255), random(255), random(255)), random(500), -10, fall_speed));
    counter = 0;
    difficulty++;
  }

  // draw boundaries
  fill(255, 0, 0);
  rectMode(CORNER);
  rect(0, 0, 500, 20);
  rect(0, height - 20, 500, 20);  
  
  // losing 
  if ((ballY <= 27) || (ballY >= height - 27)) {
    paused = true;
    background(0);
    textFont(f, 36);
    fill(255);
    text("You Lose", 175, 400);
    print(score);
  }
}

  // blocks
class Block {
  color c;
  float xpos;
  float ypos;
  float xspeed;
  float block_w;
  float block_h;

  Block (color tempC, float tempXpos, float tempYpos, float tempXspeed) {
    c = tempC;
    xpos = tempXpos;
    ypos = tempYpos;
    xspeed = tempXspeed;
    block_w = 100;
    block_h = 1;
  }
  
  //draw car
  void display() { 
    rectMode(CENTER);
    fill(c);
    rect(xpos, ypos, 100, 20);
  }
  
  // move blocks
  void drive() {
    ypos = ypos + xspeed;
    if (ypos >= height) {
      blocks.remove(this);
    }
     // collision detection
    if (rectCircleIntersect(xpos, ypos, block_w, block_h, mouseX, ballY, 10) == true) {
      collision = true;
    }
  } 
  
  // collision detection  --
  boolean rectCircleIntersect(float rx, float ry, float rw, float rh, float cx, float cy, float cr) {

    float dx = abs(cx - rx);
    float dy = abs(cy - ry);

    if ( (dx <= (rw/2 + cr)) && (dy <= (rh/2 + cr)) ) { 
      return true;
    }
    else { 
      return false;
    }
  }
}
