
/*  MATERIALS EMPRATS
TIPOGRAFIES:
https://www.dafont.com/es/game-2.font
https://www.dafont.com/es/crang.font
MUSICA:
https://juzek.itch.io/game-boy-music-loop-pack?download
ANIMACIO GALAXIA (adaptada a processing):
https://processing.org/examples/simpleparticlesystem.html
EFECTES DE SO:
https://freesound.org/people/marcuslee/
https://freesound.org/people/Ideacraft/sounds/345110/
https://freesound.org/people/Michel88/
https://freesound.org/people/SlykMrByches/sounds/55234/
https://freesound.org/people/MATRIXXX_/sounds/441225/
https://freesound.org/people/combine2005/sounds/488294/
https://freesound.org/people/Jace/sounds/19108/


*/


//per si de cas
//https://www.dafont.com/es/doomed.font
//https://www.dafont.com/es/pixelary.font

//import java.util.*;
//import controlP5.*;
import ddf.minim.*;

int mode;
int frames = 30;
String[] llistaMusica = { "BattleMusic", "BossTheme", "Chase", "Cool", "Ruins"}; 
String[] llistaLaser = { "laser1", "laser2"};
String[] llistaMonstre = {"monstre1", "monstre2", "monstre3", "monstre4"};
int musica;
int score;
PFont fontTitol;
PFont fontCos;
Minim myMinim;
AudioPlayer music;



int[] moviment = {0, 0};
int[] posició = {width/2, height/2};
//int punts;
//int vides;
IntroScreen introScreen;
GameScreen gameScreen;
GameOver gameOver;
Player player;

//Maquina d'estats
final int TITOL = 1;
final int SELECT =2;
final int JOC = 3;
final int GAMEOVER = 4;

void setup(){
  //fullScreen();
  size(1024, 768);
  myMinim = new Minim(this);
  music = myMinim.loadFile("/music/Tension.mp3");
  music.setGain(-6);
  fontTitol = createFont("/fonts/Crang.ttf", 128);
  fontCos = createFont("/fonts/Game-Font.ttf", 64); 
  frameRate (frames);
  mode = TITOL;
  introScreen = new IntroScreen();
  gameScreen = new GameScreen();
  gameOver = new GameOver();
}

void draw(){

  switch(mode){
    case TITOL:
      introScreen.introScreen();
      break;
    case SELECT:
      //mainMenu.mainMenu();
      break;
    case JOC:
      gameScreen.gameScreen(); 
      break;
    case GAMEOVER:
      gameOver.overScreen();
      break;
  }
}

void keyPressed(){
  if(mode == TITOL){
      introScreen.keyPressed();
    }
  if(mode == JOC){
    gameScreen.keyPressed();
  }
    if(mode == GAMEOVER){
    gameOver.keyPressed();
  }
}
void keyReleased(){
  if(mode == JOC){
    gameScreen.keyReleased();
  }
}

void mouseClicked(){
  if(mode == JOC){
    gameScreen.mouseClicked();
  }
}
