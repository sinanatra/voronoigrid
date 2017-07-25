int fontend = 8;
int nchars = 0;
boolean record; 
PVector object;

/// buttonz
boolean doShowPoints = true;
boolean doShowDelaunay;
boolean doClip;
boolean doSave;

// change this for grid size
int gridSize = 15;

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
  size(800, 1000, P3D);

  cp5 = new ControlP5(this);
  cp5.addSlider("slider")
    .setColorForeground(255)
    .setColorActive(255)
    .setColorLabel(0)
    .setColorValue(255)
    .setPosition(10, 10)
    .setSize(100, 20)
    .setRange(15, 50)
    .setValue(15)

    ;

  cp5.addToggle("doShowPoints")
    .setColorForeground(255)
    .setColorValue(0)
    .setColorLabel(0)
    .setPosition(10, 35)
    .setSize(100, 20)

    ;


  object = new PVector(random(width), random(height));
  setupVoronoi(); // create your voronoi generator
}

void draw() {  
  beginRaw(PDF, "output.pdf");

  background(255);

  //noLoop();
  //glued to grid
  if (key == '3') {  
    if (mousePressed) {

      object.x = mouseX;
      object.y = mouseY;
      object.x = int(object.x/gridSize)*gridSize;
      object.y = int(object.y/gridSize)*gridSize;
      drawPoint(object.x, object.y, 1, 1);
    }
  }
  if (key == '1') {
    drawPoint(mouseX, mouseY, 10, 10);
  }
  int centerLimit = 250; // variable to control the diameter of the spiral
  int theta = 20; //increases with every point in your spiral, producing the spiral effect.
  if (key == '4') {
    theta=0; //reset theta 
    for (int k=0; k<centerLimit; k++) {     
      theta +=1;
      //One spiral in center with large-ish shapes
      drawPoint(object.x, object.y, 3*theta/2, 3*theta/2);
    }
  }
  drawVoronoi(); //renders
}


void drawPoint(float orgX, float orgY, float theta, float diameter) { // generates and adds circular points
  float xPos = sin(theta)*diameter+orgX;
  float yPos = cos(theta)*diameter+orgY;
  voronoi.addPoint(new Vec2D(xPos, yPos));
}

// ranges for x/y positions of points
FloatRange xpos, ypos;

// helper class for rendering
ToxiclibsSupport gfx;

// empty voronoi mesh container
Voronoi voronoi = new Voronoi(100000);

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

void drawVoronoi() {

  //rect(0, 0, width, height);
  background(255);
  stroke(0); 
  strokeWeight(1); 
  // stroke(0);
  noFill();
  // draw all voronoi polygons, clip if needed
  for (Polygon2D poly : voronoi.getRegions()) {
    if (doClip) {
      gfx.polygon2D(clip.clipPolygon(poly));
    } else {
      gfx.polygon2D(poly);
    }
  }
  // draw delaunay triangulation
  if (doShowDelaunay) {
    stroke(0);
    fill(0);
    beginShape(TRIANGLES);
    for (Triangle2D t : voronoi.getTriangles()) {
      gfx.triangle(t, false);
    }
    endShape();
  }
  // draw original points added to voronoi
  if (doShowPoints) {
    fill(0);
    for (Vec2D c : voronoi.getSites()) {
      ellipse(c.x, c.y, 10, 10);
    }
  }

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
void keyPressed() {
  if (key == 'q') {
    endRaw();
    exit();
  }
}
