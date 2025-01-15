class IntroScreen {
  Galaxia galaxia = new Galaxia();
  int fadeValue;
  boolean fade;
  
    IntroScreen(){
      fadeValue = 254;
      fade =true;
      music.play();
    }
  void introScreen() {
    //music.play();    
    galaxia.display();
    //background(10);
    fill(255, 0, 255);
    //textSize(128);
    textFont(fontTitol);
    textAlign(CENTER, CENTER);
    text("PRÀCTICA\nFINAL", width/2, (height/3));
    //Faren que la opacitat oscili per a cridar l'atenció sobre el text:
    if(fade){
      fadeValue -= 10;
    } else {
      fadeValue += 10;
    } 
    fill(fadeValue);
    textFont(fontCos);
    text("prem espai per iniciar", width/2, (height/3)*2);
    if (fadeValue < 120 || fadeValue >244){
      fade = !fade;
    }
    fill(255);
    text("moviment amb WASD apuntar i disparar amb ratoli", width/2 , height-30);
  }
  
  void keyPressed(){
    if(key == ' '){
      music.pause();
      music = myMinim.loadFile("/music/"+ llistaMusica[int(random(llistaMusica.length))] +".mp3");  
      music.setGain(-12);
      music.loop();
      mode = JOC;
    }
  }
}

class GameOver {
  
  void overScreen() {
    background(10);
    fill(255, 0, 0);
    textFont(fontTitol);
    textAlign(CENTER, CENTER);
    text("HAS\nPERDUT", width/2, (height/3));
    fill(255);
    textFont(fontCos);
    text("has aconseguit:\n" + score + " punts", width/2, (height/3)*2);
    textAlign(LEFT);
    text("UOC - Grau Multimedia", 30, height-70);
    text("Xavi Fumado - Juny 2024", 30, height-40);
  }
  
  void keyPressed(){
    if(key == ' '){
      //gameScreen = new Gamescreen();
      gameScreen.inicialitza();
      mode = JOC;
    }
  }
}
