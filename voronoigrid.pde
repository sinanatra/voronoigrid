int fontend = 8;
int nchars = 0;
boolean record; 
PVector object;
/// state
boolean doShowPoints = true;
boolean doSave;
boolean drawGradient = false;
int gridSize = 15;// change this for grid size
int strokedim=1; // change this for strokeweight
int centerLimit = 20; // spiral diameter
int theta = 20; // for increasing spiral
int ellipsesize= 10;

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
  size(600, 800, P3D);

  cp5 = new ControlP5(this);
  cp5.addSlider("gridSize")
    .setColorForeground(255)
    .setColorActive(255)
    .setColorLabel(0)
    .setColorValue(255)
    .setColorBackground(color(0, 0, 255))

    .setPosition(10, 10)
    .setSize(100, 20)
    .setRange(15, 50)
    .setValue(15)
    ;

  cp5 = new ControlP5(this);
  cp5.addSlider("weight")
    .setColorBackground(color(0, 0, 255))

    .setColorForeground(255)
    .setColorActive(255)
    .setColorLabel(0)
    .setColorValue(255)
    .setPosition(10, 35)
    .setSize(100, 20)
    .setRange(1, 10)
    .setValue(1)
    ;

  cp5 = new ControlP5(this);
  cp5.addSlider("ellipsesize")
    .setColorBackground(color(0, 0, 255))

    .setColorForeground(255)
    .setColorActive(255)
    .setColorLabel(0)
    .setColorValue(255)
    .setPosition(10, 60)
    .setSize(100, 20)
    .setRange(10, 100)
    .setValue(10)
    ;

  cp5.addToggle("doShowPoints")
    .setColorBackground(color(0, 0, 255))

    .setColorForeground(255)
    .setColorValue(0)
    .setColorLabel(0)
    .setPosition(190, 10)
    .setSize(20, 20)
    ;
      cp5.addToggle("drawGradient")
    .setColorBackground(color(0, 0, 255))

    .setColorForeground(255)
    .setColorValue(0)
    .setColorLabel(0)
    .setPosition(190, 60)
    .setSize(20, 20)
    ;

  cp5 = new ControlP5(this);
  cp5.addSlider("centerLimit")
    .setColorBackground(color(0, 0, 255))
    .setColorForeground(255)
    .setColorActive(255)
    .setColorLabel(0)
    .setColorValue(255)
    .setPosition(10, 85)
    .setSize(100, 20)
    .setRange(20, 500)
    .setValue(20)
    ;






  object = new PVector(random(width), random(height));
  setupVoronoi(); // create your voronoi generator
}

void draw() {  
  beginRaw(PDF, "output.pdf");
  background(255);

  drawVoronoi(); //renders
}

void mouseDragged() {
  // organic shapes
  if (key == '1') {
    drawPoint(mouseX, mouseY, 0, 0, false);
  }
  if (key == '3') {
    drawPoint(mouseX, mouseY);
  }
}

void mousePressed() {
  mouseDragged();
  if (key == '4') {
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
      drawPoint( 350, k*8);
      drawPoint( 400, k*3);
      drawPoint( 450, k*8);
    }
  }

  if (key == 'q') {
    endRaw();
    exit();
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

// optional polygon clipper
PolygonClipper2D clip;


void setupVoronoi() {

  smooth();
  // focus x positions around horizontal center (w/ 33% standard deviation)
  xpos=new BiasedFloatRange(0, width, width/2, 0.333f);
  // focus y positions around bottom (w/ 50% standard deviation)
  ypos=new BiasedFloatRange(0, height, height, 0.5f);
  // setup clipper with centered rectangle
  clip=new SutherlandHodgemanClipper(new Rect(width*125, height*0.125, width*0.75, height*0.75));
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
  background(255);
  stroke(0);
  // strokeWeight(strokedim); 
  // stroke(0);
  noFill();
  // draw all voronoi polygons, clip if needed
  for (Polygon2D poly : voronoi.getRegions()) {
    Vec2D centro = getCenter(poly);

    float weight = pow(cos(poly.getArea()), 2) * (4 - 1) + 1;

    // use strokedim for same size, wieght changes by the area
    strokeWeight(weight);
    strokeWeight(strokedim);
    strokeWeight(2);

    float start = pow(cos(poly.getArea()), 2) * (255 - 63) + 63;
    float end = pow(sin(poly.getArea()), 2) * (255 - 63) + 63;
    start = 255;
    end = 0;

    int numeroScalini = 10;
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
      gfx.polygon2D(scalato);
      strokeWeight(0);
    }

    if (doShowPoints) {
      fill(0);
      strokeWeight(0);
      ellipse(centro.x, centro.y, ellipsesize, ellipsesize);
    }
  }
  // draw original points added to voronoi

  if (doSave) {
    endRecord();
    doSave = false;
  }
}

/// SLIDER ///

void slider(float sizer) {
  gridSize = int(sizer);
  println("changing grid to: "+sizer);
}
