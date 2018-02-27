import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class voronoigrid extends PApplet {

/* Visual Identity for the Academy of Fine Arts of Bologna
 giacomonanni.it */











boolean savePDF = false;
PImage img; 
int[] colors;
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

public void setup() {
  

  doClip=true;
  setupControls();

  bg = loadImage("img/pic3.jpg");
  bg.resize(0, width);

  rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);

  setupVoronoi(); // create your voronoi generator31
}

public void draw() {
  background(255);
  clipBounds.width = adjustWidth;
  clipBounds.height = adjustHeight;


  if (doSave) {
    doSave=true;
  }

  strokeJoin(BEVEL);
  int tileCount = 3; 

  float rectSize = width / PApplet.parseFloat(tileCount); 
  int i = 0; 
  colors = new int[tileCount*tileCount]; 

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
public void mouseDragged() {
  if (spirale) {
    theta=0; //reset theta
    for (int k=0; k<centerLimit; k++) {
      theta +=1;
      drawPoint(mouseX, mouseY, 3*theta/2, 3*theta/2);  //One spiral in center with l1arge-ish shapes
    }
  }
  boolean stickToGrid = !drawOrganic;
  if (drawSimmetric) {
    // symmetric shape
    drawSymmetricPoint(mouseX, mouseY, 0, 0, stickToGrid);
  } else {
    // free form
    drawPoint(mouseX, mouseY, 0, 0, stickToGrid);
  }
}

public void mousePressed() {
  boolean stickToGrid = !drawOrganic;
  if (drawSimmetric) {
    // symmetric shape
    drawSymmetricPoint(mouseX, mouseY, 0, 0, stickToGrid);
  } else {
    // free form
    drawPoint(mouseX, mouseY, 0, 0, stickToGrid);
  }
}

public void keyPressed() {


  if (doSave) {
    doSave=true;
  }
  if (key == '!') {
    int k= 0;
    for (k=0; k<width; k+=gridSize) {
      drawPoint( k, random(100, 400));
      drawPoint( k, random(100, 400));
      //
      drawPoint( k, random(350, 400));
      drawPoint( k, random(350, 400));
      //
      drawPoint( k, random(350, 650));
      drawPoint( k, random(350, 650));
    }
  }
  if (key == '1') {
    int k= 0;
  
    for (k=0; k<width; k+=gridSize) {
      drawPoint( k,  clipBounds.y + adjustHeight - gridSize);
    }
  }


  if (key == '2') {
    int k= 0;

    for (k=0; k<width; k+=gridSize) {
      drawPoint(  clipBounds.x + adjustWidth - gridSize, k);
    }
  }


  if (key =='s') {
    theta=0; //reset theta
    for (int k=0; k<centerLimit; k++) {
      theta +=1;
      //One spiral in center with l1arge-ish shapes
      drawPoint(mouseX, mouseY, 3*theta/2, 3*theta/2);
    }
  }
}

public void drawPoint(float orgX, float orgY) {
  drawPoint(orgX, orgY, 0, 0);
}
public void drawPoint(float orgX, float orgY, float theta, float diameter) {
  drawPoint(orgX, orgY, theta, diameter, true);
}
public void drawPoint(float orgX, float orgY, float theta, float diameter, boolean stickToGrid) { // generates and adds circular points
  Vec2D padding = new Vec2D(gridSize / 2, gridSize / 2);
  Vec2D point = new Vec2D(diameter, 0);
  point = point.getRotated(theta);
  point = point.add(new Vec2D(orgX, orgY));
  if (stickToGrid) {
    Vec2D centroid = clipBounds.getCentroid();
    point = point.sub(centroid);
    point = point.scale(1.0f / gridSize);
    point = new Vec2D(round(point.x), round(point.y));
    point = point.scale(gridSize);
    point = point.add(centroid);
  }

  Rect clipRect = new Rect(clipBounds.getTopLeft().add(padding), clipBounds.getBottomRight().sub(padding));
  if (doClip && !clipRect.containsPoint(point)) {
    return;
  }
  for (Vec2D existing : voronoi.getSites()) {
    if (existing.equalsWithTolerance(point, 10)) {
      return;
    }
  }
  voronoi.addPoint(point);
}

public void drawSymmetricPoint(float orgX, float orgY) {
  drawSymmetricPoint(orgX, orgY, 0, 0, true);
}
public void drawSymmetricPoint(float orgX, float orgY, float theta, float diameter, boolean stickToGrid) {

  drawPoint(orgX, orgY, theta, diameter, stickToGrid);
  float axis = clipBounds.x + clipBounds.width / 2;
  drawPoint(2 * axis - orgX, orgY, PI - theta, diameter, stickToGrid);
}
public void drawVoronoi() {

  //rect(0, 0, width, height);
  stroke(lines);
  noFill();
  for (Polygon2D poly : voronoi.getRegions()) {  // draw all voronoi polygons
    Vec2D centro = getCenter(poly);

    float weight = pow(cos(poly.getArea()), 2) * (9 - 1) + 1;
    float start = pow(cos(poly.getArea()), 2) * (860 - 63) + 63;
    float end = pow(sin(poly.getArea()), 2) * (860 - 63) + 63;
    float b = pow(sin(poly.getArea()), 2) * (100 - 1) + 1;
    float s = pow(sin(poly.getArea()), 2) * (100 - 1) + 1;
    float c = pow(sin(poly.getArea()), 2) * (100 - 1) + 1;
    b = bright;
    c= satura;
    s = sat;
    start = inizio;
    end = estremi;
    int numeroScalini = scalini;
    strokeWeight(0);

    if (!drawGradient) {
      strokeWeight(0);
      numeroScalini = 1;
      start = 255;
      end = 255;
      b = 100;
      s = 100;
      c=100;
      ///
      noFill();
    }
    float step = 1.0f / numeroScalini;
    for (float i = 1; i > 0; i -= step) {

      Polygon2D scalato = new Polygon2D();
      for (Vec2D point : poly.vertices) {
        scalato.add(new Vec2D((point.x - centro.x) * i + centro.x, (point.y - centro.y) * i + centro.y));
      }

      float colore = i * (end - start) + start;
      float brightness = i * (b - s) + s;
      float saturation = i * (c - s) + s;





      if (HSL==true) {

        strokeWeight(0);    // use strokedim for same size, weight changes by the area
        colorMode(HSB, 360, 100, 100);
        fill(colore, brightness, saturation);
      }
      if (randomColorMode) {
        colorMode(HSB, 860, 100, 100);
        strokeWeight(0);    // use strokedim for same size, weight changes by the area

        float randomColor = pow(cos(poly.getArea()), 2) * (end - start) + start;
        fill(randomColor, brightness, saturation);
      }
      if (strokeGradient==true) {
        strokeWeight(1);    // use strokedim for same size, weight changes by the area
      }

      if (bw) {
        colorMode(RGB, 255, 255, 255);
        noFill();
        strokeWeight(strokedim);    // use strokedim for same size, weight changes by the area
      }
      if (HSL==false && RGBmode == true && bw == true) {
        colorMode(RGB, 255, 255, 255);
        fill(colore, colore, colore);
        noStroke();
      } 
      if (HSL==false && RGBmode == true && bw == false ) {
        colorMode(RGB, 255, 255, 255);
        fill(colore, brightness, saturation);
        noStroke();
      } 
      if (doClip) {
        scalato = clip.clipPolygon(scalato);
      }
      gfx.polygon2D(scalato);

      if (doShowLines) {
        strokeWeight(strokedim);    // use strokedim for same size, weight changes by the area
      }
    }


    if (randomstroke) {
      strokeWeight(weight);
    }
    strokeCap(SQUARE);
    noFill();
    Polygon2D fullPoly = poly;
    if (doClip) {
      fullPoly = clip.clipPolygon(fullPoly);
    }
    if (doShowDelaunay &&(!doClip || clip.getBounds().containsPoint(centro))) {
      stroke(255, 0, 0);
      strokeWeight(strokedim);    // use strokedim for same size, weight changes by the area

      beginShape(TRIANGLES);
      for (Triangle2D t : voronoi.getTriangles()) {
        gfx.triangle(t, false);
      }
      endShape();
    }

    stroke(0);
    if (backgroundImage) {
      colorMode(HSB, 360, 100, 100);

      stroke(colors[6]);
    }
    // draw  points added to voronoi
    gfx.polygon2D(fullPoly);
    fill(PointsColor);
    if (doShowPoints && (!doClip || clip.getBounds().containsPoint(centro))) {
      strokeWeight(0);
      // float size = pow(cos(poly.getArea()), 2) * (40 - 5) + 5;

      float size = pow(cos(poly.getCircumference()), 2) * ((ellipsesize+20) - 5) + ellipsesize ;
      //float size = pow(cos(poly.getCircumference()), 2) * ((20) - 5) +5 ;
      if ( randomEllipse) {

        fill(colors[0]);          // Set the SVG fill to white

        ellipse(centro.x, centro.y, size, size);
      }
      if (randomEllipse) {
        fill(color(0, 255, 200));
        ellipse(centro.x, centro.y, size, size);
        if (backgroundImage && randomEllipse) {

          fill(colors[0]);          // Set the SVG fill to white

          ellipse(centro.x, centro.y, size, size);
        }
      } else if (Rect) {
        rectMode(CENTER);  // Set rectMode to CENTER
        fill(color(0, 255, 200));
        noStroke();
        rect(centro.x, centro.y, ellipsesize, ellipsesize);

        if (backgroundImage && Rect) {


          rectMode(CENTER);  // Set rectMode to CENTER
          fill(colors[0]);          // Set the SVG fill to white
          noStroke();
          rect(centro.x, centro.y, ellipsesize, ellipsesize);
        }
      } else {
        noStroke();
        fill(color(0, 255, 200));
        ellipse(centro.x, centro.y, ellipsesize, ellipsesize);

        if (backgroundImage) {

          fill(colors[0]);          // Set the SVG fill to white

          ellipse(centro.x, centro.y, ellipsesize, ellipsesize);
        } else {
          colorMode(RGB, 255, 255, 255);
        }
      }
    }
  }  

  if (clearCanvas) {

    voronoi = new Voronoi();
    clearCanvas = false;
    background(255);
    strokeWeight(1);
    Rect clipBounds = new Rect(375, 30, adjustWidth, adjustHeight /*280*/);// rectangle that clips everything

    rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  }
}

public Vec2D getCenter(Polygon2D polygon) {
  for (Vec2D center : voronoi.getSites()) {
    if (polygon.containsPoint(center)) {
      return center;
    }
  }

  return polygon.getCentroid();
}
public void setupControls() {
  cp5 = new ControlP5(this);
  cp5.addSlider("gridSize")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 10)
    .setSize(100, 20)
    .setRange(10, 130)
    .setValue(45)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("strokedim")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setColorValue(255)
    .setPosition(10, 35)
    .setSize(100, 20)
    .setRange(1, 30)
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
    .setRange(1, 100)
    .setValue(10)
    ;
  cp5.addToggle("doShowPoints")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("ellipse ")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 10)
    .setSize(20, 20)
    ;
  cp5.addToggle("doShowLines")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("lines visible")
    .setColorLabel(color(0, 255, 200))
    .setPosition(230, 10)
    .setSize(20, 20)
    ;
  cp5.addToggle("drawOrganic")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("organic")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 60)
    .setSize(20, 20)
    ;
  cp5.addToggle("drawSimmetric")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("Simmetric")
    .setColorLabel(color(0, 255, 200))
    .setPosition(220, 60)
    .setSize(20, 20)
    ;
  cp5.addToggle("randomEllipse")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("random ellipse size")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 100)
    .setSize(20, 20)
    ;
 /* cp5.addToggle("doShowDelaunay")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("delaunay triangulation")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 135)
    .setSize(20, 20)
    ;
    */
  cp5.addToggle("Rect")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("rect")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 175)
    .setSize(20, 20)
    ;
  /*
  cp5.addToggle("randomstroke")
   .setColorForeground(color(0, 255, 200))
   .setColorActive(color(0, 255, 200))
   .setColorValue(0)
   .setLabel("random stroke weight")
   .setColorLabel(color(0, 255, 200))
   .setPosition(190, 100)
   .setSize(20, 20)
   ;
   cp5.addToggle("doClip")
   .setColorForeground(color(0, 255, 200))
   .setColorActive(color(0, 255, 200))
   .setColorValue(0)
   .setColorLabel(color(0, 255, 200))
   .setPosition(190, 360)
   .setSize(20, 20)
   ;*/
  cp5.addToggle("backgroundImage")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(1)
    .setLabel("img color")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 355)
    .setSize(50, 20)
    ;
  cp5.addButton("clearCanvas")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(1)
    .setLabel("clear")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 405)
    .setSize(50, 20)
    ;
  cp5.addButton("doSave")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("SAVE")
    .setColorLabel(color(0, 255, 200))
    .setPosition(190, 555)
    .setSize(50, 50)
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

  cp5.addToggle("bw")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("bw")
    .setColorLabel(color(0, 255, 200))
    .setPosition(80, 150)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addToggle("HSL")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("hsl")
    .setColorLabel(color(0, 255, 200))
    .setPosition(50, 110)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addToggle("RGBmode")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(0)
    .setLabel("RGB")
    .setColorLabel(color(0, 255, 200))
    .setPosition(80, 110)
    .setSize(20, 20)
    ;

  cp5.addToggle("randomColorMode")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(1)
    .setLabel("diff")
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 150)
    .setSize(20, 20)
    ;

  cp5.addToggle("strokeGradient")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorValue(1)
    .setLabel("stroke")
    .setColorLabel(color(0, 255, 200))
    .setPosition(50, 150)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("scalini")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 200)
    .setSize(100, 20)
    .setRange(3, 50)
    .setValue(10)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("estremi")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 230)
    .setSize(100, 20)
    .setRange(0, 360)
    .setValue(255)
    ;
  cp5.addSlider("inizio")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 260)
    .setSize(100, 20)
    .setRange(0, 360)
    .setValue(0)
    ;
  cp5.addSlider("bright")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 310)
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(50)
    ;
  cp5.addSlider("satura")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 340)
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(50)
    ;
  cp5.addSlider("adjustWidth")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 370)
    .setSize(100, 20)
    .setRange(50, 450)
    .setValue(300)
    .setLabel("Width")

    ;
  cp5.addSlider("adjustHeight")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setPosition(10, 400)
    .setSize(100, 20)
    .setRange(50, 700)
    .setValue(700)
    .setLabel("Heigth")

    ;
  //SPIRAL
  /*
   cp5.addButton("spirale")
   .setColorForeground(color(0, 255, 200))
   .setColorActive(color(0, 255, 200))
   .setColorValue(1)
   .setLabel("spirale")
   .setColorLabel(color(0, 255, 200))
   .setPosition(10, 455)
   .setSize(20, 20)
   ;*/
  cp5 = new ControlP5(this);
  cp5.addSlider("centerLimit")
    .setLabel("dimensione spirale")
    .setColorForeground(color(0, 255, 200))
    .setColorActive(color(0, 255, 200))
    .setColorLabel(color(0, 255, 200))
    .setColorValue(255)
    .setPosition(10, 485)
    .setSize(100, 20)
    .setRange(20, 500)
    .setValue(20)
    ;
}

public void setupVoronoi() {

  smooth();
  // focus x positions around horizontal center (w/ 33% standard deviation)
  xpos=new BiasedFloatRange(0, width, width/2, 0.333f);
  // focus y positions around bottom (w/ 50% standard deviation)
  ypos=new BiasedFloatRange(0, height, height, 0.5f);
  // setup clipper with centered rectangle
  clip=new SutherlandHodgemanClipper(clipBounds);
  gfx = new ToxiclibsSupport(this);
}
  public void settings() {  size(850, 750, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "voronoigrid" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
