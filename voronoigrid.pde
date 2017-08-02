// Giacomo Nanni
// www.giacomonanni.it

int fontend = 8;
int nchars = 0;
boolean record; 
PVector object;
boolean doShowPoints = true;
boolean doSave;
boolean spirale;
boolean clearCanvas;
boolean clearVoronoi;
boolean drawOrganic;
boolean drawGradient = false;
boolean doClip=true;
boolean doShowHelp=true;
//  polygon clipper
SutherlandHodgemanClipper clip;
int PointsColor = 0; // color circle
//int lines = color(random(0, 20), random(0, 255), random(0, 255),70); // color lines
int lines = 0;
int gridSize = 15;// change this for grid size
int strokedim=1; // change this for strokeweight
int centerLimit = 20; // spiral diameter
int theta = 20; // for increasing spiral
int ellipsesize= 10; 
int scalini =50; // gradient steps
float inizio= 255;
float estremi= 255;
import java.util.List;
import processing.pdf.*; 
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;
import controlP5.*;
ControlP5 cp5;
int sliderValue = 100;
Slider abc;

void setup() {
  size(800, 600, P3D);
  background(255);
  doClip=true;
  rect(285, 10, 510, 580);

  cp5 = new ControlP5(this);
  cp5.addSlider("gridSize")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 10)
    .setSize(100, 20)
    .setRange(15, 90)
    .setValue(25)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("strokedim")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setColorValue(255)
    .setPosition(10, 35)
    .setSize(100, 20)
    .setRange(0, 30)
    .setValue(1)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("ellipsesize")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setColorValue(255)
    .setPosition(10, 60)
    .setSize(100, 20)
    .setRange(10, 300)
    .setValue(10)
    ;
  cp5.addToggle("doShowPoints")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("hide dots")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 10)
    .setSize(20, 20)
    ;
  
  //clearVoronoi
  cp5.addToggle("drawOrganic")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("organic")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 60)
    .setSize(20, 20)
    ;
  cp5.addToggle("doClip")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 360)
    .setSize(20, 20)
    ;
  cp5.addButton("clearCanvas")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(1)
    .setLabel("clear")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 405)
    .setSize(20, 20)
    ;


  cp5.addToggle("doSave")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("SAVE AND CLOSE")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 555)
    .setSize(20, 20)
    ;
    cp5.addToggle("drawGradient")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("gradient")
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 110)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("scalini")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 150)
    .setSize(100, 20)
    .setRange(2, 100)
    .setValue(50)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("inizio")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 200)
    .setSize(100, 20)
    .setRange(0, 255)
    .setValue(0)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("estremi")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 175)
    .setSize(100, 20)
    .setRange(0, 255)
    .setValue(255)
    ;
  cp5.addButton("spirale")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(1)
    .setLabel("spirale")
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 255)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("centerLimit")
    .setLabel("dimensione spirale")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setColorValue(255)
    .setPosition(10, 285)
    .setSize(100, 20)
    .setRange(20, 500)
    .setValue(20)
    ;
  object = new PVector(random(width), random(height));
  setupVoronoi(); // create your voronoi generator31
}

void draw() {  
  //rect(285, 10, 510, 580);

  beginRaw(PDF, "output.pdf");
  background(255);
  rect(285, 10, 510, 580);

  drawVoronoi(); //renders
}

void mouseDragged() {
  // organic shapes
  if (drawOrganic) {
    drawPoint(mouseX, mouseY, 0, 0, false);
  } else {
    drawPoint(mouseX, mouseY);
  }
}

void mousePressed() {
  mouseDragged();
  if (spirale) {
    theta=0; //reset theta 
    for (int k=0; k<centerLimit; k++) {     
      theta +=1;
      //One spiral in center with large-ish shapes
      drawPoint(mouseX, mouseY, 3*theta/2, 3*theta/2);
    }
  }
}

void keyPressed() {
  int limitone = 600; // variable to control the diameter of the spiral
  if (key == '5') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*1, k*1);
      drawPoint( k*2, k*2);
      drawPoint( k*2, k*3);
      drawPoint( k*4, k*4);
      drawPoint( k*5, k*5);
    }
  }

  if (key == '6') {

    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*2, height/8);
      drawPoint( k*2, height/7);
      drawPoint( k*2, height/6);
      drawPoint( k*2, height/5);
      drawPoint( k*2, height/4);
      drawPoint( height/8, k*2);
      drawPoint( height/7, k*2);
      drawPoint( height/6, k*2);
      drawPoint( height/5, k*2);
      drawPoint( height/4, k*2);
    }
  }

  if (key == '7') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( width/1, k*8);
      drawPoint( width/width, k*8);
    }
  }
  if (key == '8') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*6, height/1);
      drawPoint( k*6, height/height);
    }
  }
  if (key == '8') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*2, height/8);
      drawPoint( k*2, height/7);
      drawPoint( k*2, height/6);
    }
  }
}

void drawPoint(float orgX, float orgY) {
  drawPoint(orgX, orgY, 0, 0);
}
void drawPoint(float orgX, float orgY, float theta, float diameter) {
  drawPoint(orgX, orgY, theta, diameter, true);
}
void drawPoint(float orgX, float orgY, float theta, float diameter, boolean stickToGrid) { // generates and adds circular points
  float xPos = sin(theta)*diameter+orgX;
  float yPos = cos(theta)*diameter+orgY;
  if (stickToGrid) {
    xPos = round(xPos/gridSize)*gridSize;
    yPos = round(yPos/gridSize)*gridSize;
  }

  Vec2D point = new Vec2D(xPos, yPos);
  if (doClip && !clip.getBounds().containsPoint(point)) {
    return;
  }
  for (Vec2D existing : voronoi.getSites()) {
    if (existing.x == point.x && existing.y == point.y) {
      return;
    }
  }
  voronoi.addPoint(point);
}

// ranges for x/y positions of points
FloatRange xpos, ypos;

// helper class for rendering
ToxiclibsSupport gfx;

// empty voronoi mesh container
Voronoi voronoi = new Voronoi();


void setupVoronoi() {

  smooth();
  // focus x positions around horizontal center (w/ 33% standard deviation)
  xpos=new BiasedFloatRange(0, width, width/2, 0.333f);
  // focus y positions around bottom (w/ 50% standard deviation)
  ypos=new BiasedFloatRange(0, height, height, 0.5f);
  // setup clipper with centered rectangle
  //Rect clipBounds = new Rect(width*0.355, height*0.125, width*0.55, height*0.85);

  Rect clipBounds = new Rect(285, 10, 510, 580);
  clip=new SutherlandHodgemanClipper(clipBounds);
  gfx = new ToxiclibsSupport(this);
}

Vec2D getCenter(Polygon2D polygon) {
  for (Vec2D center : voronoi.getSites()) {
    if (polygon.containsPoint(center)) {
      return center;
    }
  }

  return polygon.getCentroid();
}

void drawVoronoi() {

  //rect(0, 0, width, height);
  stroke(lines);
  // strokeWeight(strokedim); 
  // stroke(0);
  noFill();
  // draw all voronoi polygons, clip if needed

  for (Polygon2D poly : voronoi.getRegions()) {

    Vec2D centro = getCenter(poly);

    //int PointsColor = color(random(0, 20), random(0, 255), random(0, 255)); // color circle
    // int lines = color(random(0, 20), random(0, 255), random(0, 255)); // color circle

    float weight = pow(cos(poly.getArea()), 2) * (4 - 1) + 1;
    // use strokedim for same size, weight changes by the area
    strokeWeight(strokedim);
    strokeCap(SQUARE);
    //strokeWeight(weight);
    float start = pow(cos(poly.getArea()), 2) * (255 - 63) + 63;
    float end = pow(sin(poly.getArea()), 2) * (255 - 63) + 63;
    start = inizio;
    end = estremi;
    int numeroScalini = scalini;

    if (!drawGradient) {
      numeroScalini = 1;
      start = 255;
      end = 255;
    }
    float step = 1.0 / numeroScalini;
    for (float i = 1; i > 0; i -= step) {
      Polygon2D scalato = new Polygon2D();
      for (Vec2D point : poly.vertices) {
        scalato.add(new Vec2D((point.x - centro.x) * i + centro.x, (point.y - centro.y) * i + centro.y));
      }
      float colore = i * (end - start) + start;
      fill(colore, colore, colore);
      if (doClip) {
        scalato = clip.clipPolygon(scalato);
      }
      gfx.polygon2D(scalato);
      strokeWeight(0);
    }

    if (doShowPoints && (!doClip || clip.getBounds().containsPoint(centro))) {
      fill(PointsColor);
      strokeWeight(0);
      ellipse(centro.x, centro.y, ellipsesize, ellipsesize);
    }
  }

  if (clearCanvas) {
    voronoi = new Voronoi();
    clearCanvas = false;
  }   

  // draw original points added to voronoi
}

/// SLIDER ///

void slider(float sizer) {
  gridSize = int(sizer);
  println("changing grid to: "+sizer);


  if (doSave) {
    endRaw();
    //stop();
    exit();
  }
  if (doClip) {
    background(255);
    doClip=!doClip;
  }
}
