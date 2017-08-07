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
boolean drawSimmetric;
boolean drawGradient = false;
boolean randomstroke;
boolean randomEllipse;
boolean doShowLines=true;
boolean HSL;
boolean randomColorMode;
boolean doClip=true;
boolean doShowHelp=true;
boolean doShowDelaunay;
//  polygon clipper
SutherlandHodgemanClipper clip;
int PointsColor = 0; // color circle
int lines = 0;
int gridSize = 15;// change this for grid size
int strokedim=1; // change this for strokeweight
int centerLimit = 20; // spiral diameter
int theta = 20; // for increasing spiral
int ellipsesize= 10;
int scalini =50; // gradient steps
int sliderValue = 100;

float inizio= 255;
float estremi= 255;
float bright=100;
float sat=100;
float satura=100;
ControlP5 cp5;
Slider abc;
FloatRange xpos, ypos;// ranges for x/y positions of points
ToxiclibsSupport gfx;// helper class for rendering
Voronoi voronoi = new Voronoi();// empty voronoi mesh container
Rect clipBounds = new Rect(375, 30, 400, 680);// rectangle that clips everything

void setup() {
  size(850, 750, P2D);
  doClip=true;
  setupControls();
  background(255);
  rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  setupVoronoi(); // create your voronoi generator31
}

void draw() {

  strokeJoin(BEVEL);
  background(255);

  if (voronoi.getSites().size() == 0) {
    rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  }
  if (doSave) {
    beginRaw(PDF, "output/ababo-####.pdf");
  }
  drawVoronoi(); //renders

  if (doSave) {
    endRaw();
    doSave = false;
  }
}