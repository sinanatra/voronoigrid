/* Visual Identity for the Academy of Fine Arts of Bologna
 giacomonanni.it */
import java.util.List;
import processing.pdf.*;
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;
import controlP5.*;
import generativedesign.*;
import processing.pdf.*;
import java.util.Calendar;
boolean savePDF = false;
PImage img; 
color[] colors;
String sortMode = null; 
PShape fama;
PShape pattern;
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
boolean drawGradient;
boolean color_RGB;
boolean randomstroke;
boolean randomEllipse;
boolean doShowLines=true;
boolean HSL;
boolean RGBmode = false;
boolean randomColorMode;
boolean doClip=true;
boolean doShowHelp=true;
boolean doShowDelaunay;
boolean strokeGradient;
boolean backgroundImage;
boolean Rect;
boolean bw;
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
int adjustWidth ;
int adjustHeight;
PImage bg;
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

Rect clipBounds = new Rect(375, 30, adjustWidth, adjustHeight /*280*/);// rectangle that clips everything

void setup() {
  size(850, 750, P2D);

  doClip=true;
  setupControls();

  bg = loadImage("img/pic3.jpg");
  bg.resize(0, width);

  rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);

  setupVoronoi(); // create your voronoi generator31
}

void draw() {
  background(255);
  clipBounds.width = adjustWidth;
  clipBounds.height = adjustHeight;


  if (doSave) {
    doSave=true;
  }

  strokeJoin(BEVEL);
  int tileCount = 3; 

  float rectSize = width / float(tileCount); 
  int i = 0; 
  colors = new color[tileCount*tileCount]; 

  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {
      int px = (int) (gridX * rectSize); 
      int py = (int) (gridY * rectSize); 
      colors[i] = bg.get(px, py);
      i++;
    }
  }
  // sort colors
  sortMode = GenerativeDesign.HUE;
  if (sortMode != null) colors = GenerativeDesign.sortColors(this, colors, sortMode); 


  if (voronoi.getSites().size() > 0) {
    noFill();
    rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  }
  if (voronoi.getSites().size() == 0) {
    rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  }
  if (doSave) {
    // beginRecord(PDF, "everything.pdf");

    beginRaw(PDF, "output/ababo-####.pdf");
  }
  drawVoronoi(); //renders

  if (doSave) {
    endRaw();
    //endRecord();
    doSave = false;
  }
}