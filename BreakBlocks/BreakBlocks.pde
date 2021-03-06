ArrayList<Block> _blocks;
Shooter _s;
//variables related to game events
boolean _start, _over, _readyToClick, _readyToAdd, _pressed;
int _score, _pScore;
float _blockSpawnChance, _blockSpawnCount, _doubleHealthChance;
float _mouseX, _mouseY, _currX;

void setup() {

  size( 1000, 600 );

  _blocks = new ArrayList();
  _currX = width / 2;
  _score = 0;
  
  _blockSpawnCount = 1.5;
  updateChance();
  _doubleHealthChance = 0.7;
  
  _start = false;
  _over = false;
  _readyToClick = true;
  _readyToAdd = true;
}

//helper methods
void updateChance(){
  _blockSpawnChance = 1 - 1 / _blockSpawnCount;
  _blockSpawnCount += 0.02;
}

void gameOver() {//oh no
  clear();
  _blockSpawnCount = 1.5;
  fill(255);
  textSize( 64 );//font size
  text( "GAME OVER", 300, 300 );
  textSize( 16 );//font size
  text( "Score: " + _pScore, 300, 400 );
  textSize( 16 );//font size
  text( "Left Click to Start" , 300, 500 );
}

void startingMenu() {
  fill(255);
  textSize( 64 );//font size
  text( "Break Blocks", 300, 300 );
  textSize( 16 );//font size
  text( "Left click to start", 300, 400 );
}

void addBlocks(){
  for (Block b : _blocks)
    b.moveDown();
  for (int x = 50; x < width; x += 100)
    if (Math.random() < _blockSpawnChance)
      if (Math.random() < _doubleHealthChance)
        _blocks.add( new Block(x, 75, _score) );
      else
        _blocks.add( new Block(x, 75, _score * 2) );
}

void currentScore(){
  fill(255);
  textSize(25);
  text( "Score: " + _score, 30, height - 30);
}

void runGame(){
  
  currentScore();
  for (int i = 0; i < _blocks.size(); i ++){
    _blocks.get(i).spawn();
    if ( !_blocks.get(i).isAlive() ){
      _blocks.remove(i);
      i --;
    }
  }
  
  _s.tick();
  
  if (_pressed){
    stroke(255);
    makeLine(mouseX, mouseY);
    stroke(0);
  }
  
  float x = _s.nextX();
  if (x >= 0)
    _currX = x;
  
  if (_readyToAdd){
    addBlocks();
    _readyToClick = true;
    _readyToAdd = false;
  }
  
  if (_s.isDone()){
    _readyToAdd = true;
    //_currX = (float)Math.random() * width;
  }
  
  fill(255);
  ellipse(_currX, height - 4, 16, 16);
  
  for (Block b : _blocks)
    if (b.getY() == 575)
      _over = true;
  
}

void draw() {
  clear();
  if (!_start) {
    startingMenu();
  } else if (_over){
    if (_score != 0){
      _pScore = _score;
      _score = 0;
    }
    gameOver();
  } else {
    runGame();
  }
}

void mouseClicked(){
  if (!_start)
    _start = true;
  if (_over){
    _over = false;
    while (!_blocks.isEmpty())
      _blocks.remove(0);
  }
  //if (_readyToClick){
  //  _readyToClick = false;
  //  updateChance();
  //  _s = new Shooter(_score, _currX, mouseX, mouseY, _blocks);
  //  _score ++;
  //}
}

void mousePressed(){
  if (_readyToClick)
    _pressed = true;
}

void mouseReleased(){
  if (_readyToClick){
    _readyToClick = false;
    _pressed = false;
    updateChance();
    _s = new Shooter(_score, _currX, mouseX, mouseY, _blocks);
    _score ++;
  }
}

void makeLine(float x, float y){
  float diffX = x - _currX;
  float diffY = y - height;
  float hyp = sqrt( sq(diffX) + sq(diffY) );
  float dx = diffX / hyp;
  float dy = diffY / hyp;
  float endX = _currX;
  float endY = height;
  boolean hitBox = false;
  while (endX > 0 && endX < width && endY > 0 && !hitBox){
    endX += dx;
    endY += dy;
    for (Block b : _blocks)
      if (withinBlock( endX, endY, b ))
        hitBox = true;
  }
  line(_currX, height, endX, endY);
}

boolean withinBlock(float x, float y, Block b){
  return x > b.getX() - b.getHalfL() &&
         x < b.getX() + b.getHalfL() &&
         y > b.getY() - b.getHalfW() &&
         y < b.getY() + b.getHalfW();
}
