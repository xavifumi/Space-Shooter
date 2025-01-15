class Player {
  //propietats
  PVector pos, speed, actualSpeed, correccio, rotMotor;
  PImage avatar, fxMotor, explosio;
  int DIM = 4;
  PImage[] exploSprites = new PImage[DIM*DIM];
  float w, h;
  float maxSpeed, accel, playerRot, duradaInvencible, fadeValue;
  float angle = 0.0;
  int vida, framesFi;
  ArrayList<Bala> bales;
  StopWatch invencible;
  boolean tintar, motor, mort, fiPartida;
  color colorTintar;
  float duradaTintar = 0;
  float timerFinal;
  AudioPlayer spaceship;
  AudioPlayer shoot;
  
  //inicialitzem
  Player(){
    avatar = loadImage("/sprites/ship.png");
    fxMotor = loadImage("/sprites/effect_yellowB.png");
    explosio = loadImage("/sprites/explosio.png");
    spaceship = myMinim.loadFile("/fx/spaceship.wav");
    spaceship.setGain(-6);
    //generem els sprites de l'explosió emprant un spritesheet
    int explW = explosio.width/DIM;
    int explH = explosio.height/DIM;
    for (int i=0; i<exploSprites.length; i++) {
      int x = i%DIM*explW;
      int y = i/DIM*explH;
      exploSprites[i] = explosio.get(x, y, explW, explH);
      fiPartida = false;
      timerFinal = 50;
    }
    vida = 20;
    bales = new ArrayList<Bala>();
    pos = new PVector(width/2, height/2);
    speed = new PVector(0, 0);
    actualSpeed = new PVector(0, 0);
    correccio = new PVector(0, 0);
    rotMotor = new PVector(0,0);
    w = avatar.width;
    h = avatar.height;
    maxSpeed = accel =  10;
    playerRot = 0;
    invencible = new StopWatch();
    duradaInvencible = 0.5;
    motor = false;
    mort = false;
    fadeValue = 120;
  }
  
  //si el jugador és viu es pot moure:
  void update(int mx, int my){  
    if(!mort){
      if (moviment[0]<0) {
        speed.x = -1;
      }
      if(moviment[0]>0 ){
        speed.x = +1;
      }
      if (moviment[1]<0) {
        speed.y = -1;
      }
      if(moviment[1]>0){
        speed.y = +1;
      }
      if(moviment[0] == 0){
        speed.x = 0;
      }
      if(moviment[1] == 0){
        speed.y = 0;
      }
    } 
    //Per a fer que no es mogui més ràpid en diagonal pel teorema de pitàgores x2 + y2 = diagonal2 = 1.4
    //normalitzem el vector primer i després el multipliquem per la velocitat.
    speed.normalize();
    speed.mult(maxSpeed);
    //fem que la velocitat vagi canviant poc a poc a la que serà la definitiva fingint una fricció o resistència
    //correccio.set(speed.sub(actualSpeed));
    correccio.set(speed.x - actualSpeed.x, speed.y - actualSpeed.y);
    actualSpeed.x += correccio.x*0.1;
    actualSpeed.y += correccio.y*0.1;
    player.pos.x += actualSpeed.x;
    player.pos.y += actualSpeed.y;
    player.playerRot = actualSpeed.heading();
    //Que no surti dels marges de la pantalla
    if(player.pos.x > width){player.pos.x = width;}
    if(player.pos.x < 0){player.pos.x = 0;}
    if(player.pos.y > height){player.pos.y = height;}
    if(player.pos.y < 0){player.pos.y = 0;}
    angle = atan2(my-player.pos.y, mx-player.pos.x);
  }
  
  void display(){
    //sprite del jugador
    fill(255);
    imageMode(CENTER);
    ellipseMode(CENTER);
    pushMatrix();
    //Per si de cas, limitem les posicions del jugador dins la pantalla     
      translate(constrain(player.pos.x, 0, width), constrain(player.pos.y, 0, height)); 
        //l'angle de la flama ha de intentar corregir l'angle de la nau perquè arribi a ser el que li indiquem.
        pushMatrix();      
          rotMotor.x = speed.x - correccio.x;
          rotMotor.y = speed.y - correccio.y;
          rotate(rotMotor.heading());
          //animem l'oscilació de transparència de la flama
          if(moviment[0]!=0 || moviment[1]!=0){
            if(!spaceship.isPlaying())
              spaceship.loop();
            if(motor){
                fadeValue -= 20;
            } else {
                fadeValue += 20;
            } 
            if (fadeValue < 120 || fadeValue >244){
              motor = !motor;
            }
            tint(255, fadeValue);
            image(fxMotor, -avatar.width+fxMotor.width/2, 0, random(fxMotor.width/2, fxMotor.width), fxMotor.height);
            noTint();
          } else {
          spaceship.pause();
          }
        popMatrix();
      pushMatrix();
      //sprite principal, el carreguem 2 cops un per efecte de tintar en rebre dany
        rotate(playerRot);    
        image(avatar, 0, 0, avatar.width, avatar.height);
        if(tintar){
          tint(colorTintar, duradaTintar);
          duradaTintar -= 255/20;
        }
        image(avatar, 0, 0, avatar.width, avatar.height);
        noTint();
        if(mort && !fiPartida){
          //triger de fi de partida que volem executar només un cop
          music.shiftGain(-12, -100, 3000);   
          spaceship = myMinim.loadFile("/fx/explosio.wav");
          fiPartida = true;
        } else if (mort){
          spaceship.play();
          mort();    
        }
      popMatrix(); 
     //cursor del canó
      stroke(0, 0, 255);
      strokeWeight(4);
      rotate(angle);
      translate(100, 0);
      rotate(-angle);
      fill(0);
      line(-7, 0, 7, 0);
      line(0, -7, 0, 7);
      noStroke();
    popMatrix(); //1
    imageMode(CORNER);
    ellipseMode(CORNER);
    
  }
  //si el jugador és viu pot disparar:
  void mouseClicked(){
    if (!mort){
      shoot = myMinim.loadFile("/fx/"+ llistaLaser[int(random(2))] +".wav");
      shoot.setGain(-6);
      shoot.play();
      player.bales.add(new Bala(player.pos, angle));
    }
  }
  
  //seqüència de mort, activem compte enrere i animació d'explosions
  void mort(){ 
      if(timerFinal > 0){
        image(exploSprites[frameCount%exploSprites.length], 0, 0, 96, 96);
        timerFinal--;
      }else{ // en acabar temporitzador canviem a GAMEOVER
        music.pause();
        music = myMinim.loadFile("/music/Throne.mp3");  
        music.setGain(-9);
        music.play(); 
        mode = GAMEOVER;
      }
  }
  
} //Fi Player
