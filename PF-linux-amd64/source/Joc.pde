class GameScreen {

  ArrayList<Enemic> enemics;
  ArrayList<Particle> particles;
  Galaxia galaxia = new Galaxia();
  StopWatch generador;
  int enemicsInicials;
  int llencador;
  int maximEnemics = 40;

  
  GameScreen(){
    inicialitza();
  }
  
  void gameScreen(){
    //background(120);
    galaxia.display();
    ompleEnemics();
    if(generador.getRunTime()+ constrain(enemics.size(), 0, 14)>15 && enemics.size()<=maximEnemics){
      enemics.add(new Enemic(random(width), random(height)));
      generador.reset();
    }
    for (int i=0; i< player.bales.size(); i++){
      player.bales.get(i).display();
      player.bales.get(i).update();
      for (int j=0; j< enemics.size(); j++){
        Enemic e = enemics.get(j);
        if(enemics.get(j).pos.dist(player.bales.get(i).pos)<enemics.get(j).h/2){    
          e.monstreHit = myMinim.loadFile("/fx/"+llistaMonstre[int(random(llistaMonstre.length-1))]+".wav");
          e.monstreHit.setGain(-3);
          e.monstreHit.play();
          color c = color(0, 255, 0);
          e.duradaTintar = 255;
          e.colorTintar = c;
          e.tintar = true;
          e.dany();
          player.bales.get(i).destroy = true;
          c = color(0, 255, 0);
          PVector angle = new PVector(0,0);
          angle.x= -player.bales.get(i).velocity.x;
          angle.y= -player.bales.get(i).velocity.y;
          for(int k=0; k < random(2,5); k++){
            particles.add(new Particle(player.bales.get(i).pos, angle , c ));
          }
        }
      }
      if(player.bales.get(i).destroy){
        player.bales.remove(i);
      }
    }
    for (int i=0; i< enemics.size(); i++){
      Enemic e = enemics.get(i);
      //primer comprovem que no s'acostin massa entre ells els enemics!
      for (int j=0; j< enemics.size(); j++){
        float d = PVector.dist(e.pos, enemics.get(j).pos);
        //no comparem un enemic amb ell mateix!
        if ((d < 80) && i!=j) {
          PVector separa = new PVector(0,0);
          separa.x = e.pos.x - enemics.get(j).pos.x;
          separa.y = e.pos.y - enemics.get(j).pos.y;
          separa.normalize();
          e.pos.add(separa);
        } 
      }
      if(player.mort){
        e.estat = "pausa";
      }
      e.display();
      e.update();
      if(e.destroy){
        e.monstreHit = myMinim.loadFile("/fx/mortMonstre.mp3");
        e.monstreHit.play();
        enemics.remove(i);
        score += 1;
        //enemics.add(new Enemic(random(width), random(height)));
      }

    }

    player.update(mouseX, mouseY);
    player.display();
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
    if (p.destroy) {
      particles.remove(i);
    }
  }
  gui();
  //si buidem la pantalla es reomple, una mica més difícil.
  if (enemics.size() == 0){
    enemicsInicials++;
    llencador = 0;
    ompleEnemics();  
  }
  }
  
  void dany(){
    player.invencible.reset();
    if(player.vida>0){
      player.vida -= 1;
    } else {
      player.mort = true;
      player.mort();
      
    }
  } 
  
  void puntua(){
     score = score + 10;
  }
  
  void keyPressed(){
 
  switch(keyCode){
    case LEFT:
      moviment[0] = -1;
      break;
    case RIGHT:
      moviment[0] = 1;
      break;
    case UP:
      moviment[1] = -1;
      break;
    case DOWN:
      moviment[1] = 1;
      break;
  }
  switch(key){
    case 'a':
      moviment[0] = -1;
      break;
    case 'd':
      moviment[0] = 1;
      break;
    case 'w':
      moviment[1] = -1;
      break;
    case 's':
      moviment[1] = 1;
      break;
  }

}
  void keyReleased(){

    switch(keyCode){
      case LEFT:
      case RIGHT:
        moviment[0] = 0;
        break;
      case UP:
      case DOWN:
        moviment[1] = 0;
        break;
    }
      switch(key){
    case 'a':
    case 'd':
      moviment[0] = 0;
      break;
    case 'w':
    case 's':
      moviment[1] = 0;
      break;
    }
  }
  
  void mouseClicked(){
    player.mouseClicked();
  }
  
  void gui(){
    rectMode(CORNER);
    noFill();
    stroke(120);
    strokeWeight(2);
    rect(10, 10, 200, 30, 4);
    noStroke();
    fill(0, 255, 0);
    for (int i = 15; i<=36; i++ ){
      color from = color(0, 255, 0);
      color to = color(0, 100, 0);
      stroke(lerpColor(from, to, (i-14)*0.04));
      strokeWeight(1);
      line(15, i,  int(map(player.vida, 0, 20, 15, 206)), i );
    }
    //rect(15, 15, map(player.vida, 0, 20, 0, 191), 21, 2 );
    textAlign(LEFT);
    textSize(30);
    fill(255);
    noStroke();
    textFont(fontCos);
    text("SCORE: " + score, 12, 70 );
    text("ENEMICS: " + enemics.size(), 12, 100);
    text("FPS: " + frameCount/(millis()/1000), 12, 130);
    //text("TEMPS: "+player.invencible.getRunTime(), 10, 600);
  }

  void inicialitza(){
    generador = new StopWatch();
    player = new Player();
    enemics = new ArrayList<Enemic>();
    particles = new ArrayList<Particle>();
    score = 0;
    llencador = 0;
    enemicsInicials = 5;

  }
  
  //generar enemics si la pantalla es buida
  void ompleEnemics(){
      if(generador.getRunTime()>llencador && enemics.size() < enemicsInicials && enemics.size()<=maximEnemics){
        enemics.add(new Enemic(random(width), random(height)));
      llencador = int((float)generador.getRunTime())+1;
    } 
  }

}


  
class Bala {
  int dany;
  PVector pos;
  float angle;
  boolean destroy;
  PVector velocity;

  // Constructor que toma la posición y el ángulo del jugador
  Bala(PVector playerPos, float playerAngle) {
    dany = 1;
    pos = playerPos.copy();
    angle = playerAngle;
    destroy = false;
    // Calcular la velocitat en base a l'angle
    float speed = 10;
    velocity = new PVector(cos(angle) * speed, sin(angle) * speed);
  }

  void display() {
    pushMatrix();
      translate(pos.x, pos.y); 
      noStroke();
      //La bala té 3 cercles de diferents opacitats per fingir una estela
      fill(255, 120, 0, 80);
      circle(-velocity.x*2, -velocity.y*2, 10);
      fill(255, 120, 0, 160);
      circle(-velocity.x, -velocity.y, 10);
      fill(255);
      strokeWeight(5);
      stroke(255, 120, 0);
      circle(0, 0, 10);  
    popMatrix();
    noStroke();
  }

  void update() {
    //actualitzem posició i si surt fora pantalla destruim
    pos.add(velocity);
    if (pos.x >width || pos.x<0 || pos.y >height || pos.y<0){
    destroy = true;
    }
  }
} // Fi Objecte BALA

class Enemic {
  //propietats
  PVector pos, velocity;
  PImage avatar;
  float w, h, maxSpeed;
  float angle = 0.0;
  int vida;
  ArrayList<Bala> bales;
  boolean destroy, fxPlay;
  String estat;
  boolean tintar = false;
  color colorTintar;
  float duradaTintar = 0;
  float heightAnim, widthAnim;
  StopWatch cronoAparicio;
  AudioPlayer monstreFX;
  AudioPlayer monstreHit;
  AudioPlayer cop;
  
  //inicialitzem
  Enemic(float posX, float posY){
    avatar = loadImage("/sprites/Monstre"+ int(random(0,3))+"00.png");
    vida = 5;
    bales = new ArrayList<Bala>();
    pos = new PVector(posX, posY);
    w = avatar.width;
    h = avatar.height;
    maxSpeed = 3;
    destroy = false;
    fxPlay = false;
    estat = "aparicio";
    // Calcular la velocidad en base al ángulo
    velocity = new PVector();
    cronoAparicio = new StopWatch();
    widthAnim = 0;
    heightAnim = avatar.height*2;
    monstreFX = myMinim.loadFile("/fx/teleport.wav");
    monstreFX.setGain(-9);
    cop = myMinim.loadFile("/fx/cop.wav");
    cop.setGain(-6);
  }
  
   void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    fill(0);
    stroke(255, 0, 0);
    strokeWeight(2);
    rectMode(CENTER);
    //rect(0, 0, h, w);  // Dibujar la bala en la posición (0, 0) relativa
    //image(avatar, 0, 0, avatar.width, avatar.height);
        image(avatar, 0, 0, widthAnim, heightAnim);
        if(tintar){
          tint(colorTintar, duradaTintar);
          duradaTintar -= 255/20;
        }
        image(avatar, 0, 0, widthAnim, heightAnim);
        noTint();
    rectMode(CORNER);
    popMatrix();
    noStroke();
  }

  void update() {
    //flock(gameScreen.enemics);
    switch(estat){
      case "atac":
        atac();
        break;
      case "aparicio":
        aparicio();
        break;
      case "destruccio":
        destruccio();
        break;
      case "pausa":
        pausa();
        break;
    }
  }
  
  void aparicio(){
    if (!fxPlay){
      monstreFX.play();
      fxPlay = true;
    }

      if (widthAnim < avatar.width){
        widthAnim+=5;
        if (heightAnim > avatar.height){
          heightAnim-=5;
        }
      } else {
        widthAnim = avatar.width;
        heightAnim = avatar.height;
        estat = "atac";
        fxPlay= false;
      }
  
  }
  
  void atac(){
    //Si el jugador és lluny ens hi acostem
    //Primer calculem el vector de direcció
    
    if(player.pos.dist(pos) > h){  
      velocity.x = pos.x-player.pos.x;
      velocity.y = pos.y-player.pos.y;
    }
    if(!cop.isPlaying()){
    cop.rewind();
    }
    //ajustem a la velocitat del eniemic i modifiquem posició
    velocity.normalize();
    velocity.mult(maxSpeed);
    pos.sub(velocity);
    //Si toquem el jugador quan no és invencible li fem mal
    if(player.pos.dist(pos) <= h && player.invencible.getRunTime()>player.duradaInvencible){
      cop.play();
      gameScreen.dany();
      //Tintem el jugador de color vermell per indicar el dany
      color c = color(255, 0, 0);
      player.duradaTintar = 255;
      player.colorTintar = c;
      player.tintar = true;
      //creem particules efecte "sang"
      for(int k=0; k < random(2,5); k++){
        gameScreen.particles.add(new Particle(player.pos, velocity , c ));
      }
    }
  }
 
  /*
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    velocity.add(force);
  }
  
  void flock(ArrayList<Enemic> enemics) {
    PVector sep = separate(enemics);   // Separation
  // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    // Add the force vectors to acceleration
    applyForce(sep);
  }

  
  PVector separate (ArrayList<Enemic> enemics) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Enemic other : enemics) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        print("it's flocking!\n");
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(5);
      steer.sub(velocity);
      steer.limit(10);
    }
    return steer;
  }*/
  
  void destruccio(){
      monstreFX.play();
      fxPlay = true;

      if (widthAnim > 0){
        widthAnim-=5;
        if (heightAnim < avatar.height*2){
          heightAnim+=5;
        }
      } else {
        widthAnim = 0;
        heightAnim = avatar.height*2;
        destroy = true;
      }
  }
  
  void dany(){
      if(vida>0){
      vida -= 1;
    } else {
      estat = "destruccio";
    }
  }
  
  void pausa(){
  }
} //Fi Objecte ENEMIC

class Particle {
  PVector position;
  PVector velocity;
  float fadeOut;
  color tonalitat;
  boolean destroy;

  Particle(PVector XY, PVector direction, color to) {
    position = XY.copy();
    float angle = direction.heading() + random(-0.4, 0.4);
    velocity = PVector.fromAngle(angle);
    velocity.setMag(random(10,30));
    tonalitat = to;
    fadeOut = 255.0;
    destroy = false;
  }

  void update() {
    position.add(velocity.mult(0.8));
    if(fadeOut > 0.0){
      fadeOut -= 255.0 / 10.0; 
    } else{
      destroy = true;
    }
  }

  void display() {
    noStroke();
    fill(tonalitat, fadeOut);
    rect(position.x, position.y, 10, 10);
  }

}
