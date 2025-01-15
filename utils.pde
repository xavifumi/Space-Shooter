//Objecgte Temporitzador, codi agafat de StackOverflow
public class StopWatch {
  private long currTime;
  private long lastTime;
  private long lapTime;
  private long startTime;

  public StopWatch() {
    reset();
  }

  // Resetejar el temporitzador
  public void reset() {
    currTime = lastTime = startTime = System.nanoTime();
    lapTime = 0;
  }

  // Temps des de l'últim reset()
  public double getRunTime() {
    double rt = 1.0E-9 * (System.nanoTime() - startTime);
    return rt;
  }

  // Temps transcorregut des de l'últim cop que s'ha cridat aquesta funció
  public double getElapsedTime() {
    currTime = System.nanoTime();
    lapTime = currTime - lastTime;
    lastTime = currTime;
    return 1.0E-9 * lapTime;
  }
}

class Galaxia{
  int worldSize = width;
  int nStars = 600; 
  float maxS = 4.0;
  float[] s = new float[nStars];
  float[] x = new float[nStars];
  float[] y = new float[nStars];
  float angle, speed;
  float speedX, speedY;
  
  Galaxia(){
    background(0);
    float t = (1.0 - 1.0 / (maxS * maxS * maxS)) / (nStars - 1);
    for (int i = 0; i < nStars; i++) {
      s[i] = pow(1.0 / (1.0 - t * i), 0.33333333);
      x[i] = random(worldSize + 8.0 * s[i]);
      y[i] = random(worldSize + 8.0 * s[i]);
    }
  
    angle = -0.2;
    speed = 8.0 / maxS;
  }
  
  void display(){
    background(0, 128);
    speedX = speed * cos(angle);
    speedY = speed * sin(angle);
   
    for (int i = 0; i < nStars; i++) {
      if (x[i] < worldSize + 2 * s[i] && y[i] < worldSize + 2 * s[i]) {
        strokeWeight(s[i]);
        stroke(map(s[i], 1.0, maxS, 128, 255));
        line(x[i] - s[i], y[i] - s[i], 
             x[i] - s[i] + speedX * (s[i] - 0.99), y[i] - s[i] + speedY * (s[i] - 0.99));
      }
      float wrap = worldSize + 8.0 * s[i];
      x[i] = (x[i] - speedX * (s[i] - 0.99) + wrap) % wrap;
      y[i] = (y[i] - speedY * (s[i] - 0.99) + wrap) % wrap;
    }
  }
}
