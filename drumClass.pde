import ddf.minim.*;
import SimpleOpenNI.*;
import processing.opengl.*;

Minim minim;
AudioSnippet kick;
AudioSnippet snare;

Hotpoint snareTrigger;
Hotpoint kickTrigger;

SimpleOpenNI kinect;

float rotation = 0;

float s = 1;

void setup() {

  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  kinect.setMirror(false);


  minim = new Minim(this);
  kick = minim.loadSnippet("kick.wav");
  snare = minim.loadSnippet("snare.wav");
  

  snareTrigger = new Hotpoint(200, 0, 600, 150);
  kickTrigger = new Hotpoint(-200, 0, 600, 150);
}

void draw() {

  background(0);
  kinect.update();


  translate(width/2, height/2, -1000);
  rotateX(radians(180));

  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));

  translate(0, 0, s*-1000);
  scale(s);

  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  for (int i = 0; i < depthPoints.length; i+=10) {

    PVector currentPoint = depthPoints[i];

    snareTrigger.check(currentPoint);
    kickTrigger.check(currentPoint);

    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }

  //println(snareTrigger.pointsIncluded);

  if (snareTrigger.isHit()) {

    snare.play();
  }

  if (kickTrigger.isHit()) {
    kick.play();
  }

  if (!kick.isPlaying()) {
    kick.rewind();
  }

  if (!snare.isPlaying()) {
    snare.rewind();
  }

  snareTrigger.draw();
  snareTrigger.clear();

  kickTrigger.draw();
  kickTrigger.clear();
}

void stop() {

  kick.close();
  snare.close();

  minim.stop();
  super.stop();
}

//up and down arrows for zooming
void keyPressed() {

  if (keyCode == 38) {
    s = s + 0.01;
  }
  if (keyCode == 40) {
    s = s - 0.01;
  }
}

