// Giacomo Nanni
// www.giacomonanni.it

import java.util.List;
import processing.pdf.*; 
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;
import controlP5.*;

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
ControlP5 cp5;
int sliderValue = 100;
Slider abc;

// ranges for x/y positions of points
FloatRange xpos, ypos;

// helper class for rendering
ToxiclibsSupport gfx;

// empty voronoi mesh container
Voronoi voronoi = new Voronoi();

Rect clipBounds = new Rect(285, 10, 510, 580);

void setup() {
  size(800, 600, P3D);
  background(255);
  doClip=true;
  setupControls();
  setupVoronoi(); // create your voronoi generator31
}

void draw() {  

  beginRaw(PDF, "data/output.pdf");
  background(255);
  rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);

  drawVoronoi(); //renders
  
}