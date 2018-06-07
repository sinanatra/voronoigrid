void setupControls() {
  cp5 = new ControlP5(this);
  cp5.setColorBackground(backgroundcolor);

  cp5.addSlider("gridSize")
    .setColorBackground(backgroundcolor)
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 10)
    .setSize(100, 20)
    .setRange(10, 130)
    .setValue(45)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("strokedim")
  
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setColorValue(255)
    .setPosition(10, 35)
    .setSize(100, 20)
    .setRange(1, 30)
    .setValue(1)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("ellipsesize")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setColorValue(255)
    .setPosition(10, 60)
    .setSize(100, 20)
    .setRange(1, 100)
    .setValue(10)
    ;
  cp5.addToggle("doShowPoints")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("ellipse ")
    .setColorLabel(colorscheme)
    .setPosition(190, 10)
    .setSize(20, 20)
    ;
  cp5.addToggle("doShowLines")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("lines visible")
    .setColorLabel(colorscheme)
    .setPosition(230, 10)
    .setSize(20, 20)
    ;
  cp5.addToggle("drawOrganic")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("organic")
    .setColorLabel(colorscheme)
    .setPosition(190, 60)
    .setSize(20, 20)
    ;
  cp5.addToggle("drawSimmetric")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("Simmetric")
    .setColorLabel(colorscheme)
    .setPosition(220, 60)
    .setSize(20, 20)
    ;
  cp5.addToggle("randomEllipse")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("random ellipse size")
    .setColorLabel(colorscheme)
    .setPosition(190, 100)
    .setSize(20, 20)
    ;
  cp5.addToggle("doShowDelaunay")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("delaunay triangulation")
    .setColorLabel(colorscheme)
    .setPosition(190, 220)
    .setSize(20, 20)
    ;
   /* 
  cp5.addToggle("Rect")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("rect")
    .setColorLabel(colorscheme)
    .setPosition(190, 175)
    .setSize(20, 20)
    ;
    */
 /*
  cp5.addToggle("randomstroke")
   .setColorForeground(colorscheme)
   .setColorActive(colorscheme)
   .setColorValue(0)
   .setLabel("random stroke")
   .setColorLabel(colorscheme)
   .setPosition(220, 310)
   .setSize(20, 20)
   ;
   */
   cp5.addToggle("doClip")
   .setColorForeground(colorscheme)
   .setColorActive(colorscheme)
   .setColorValue(0)
   .setColorLabel(colorscheme)
   .setPosition(190, 310)
   .setSize(20, 20)
   ;
   
   /*
  cp5.addToggle("backgroundImage")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(1)
    .setLabel("img color")
    .setColorLabel(colorscheme)
    .setPosition(190, 355)
    .setSize(50, 20)
    ;
    */
  cp5.addButton("clearCanvas")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(1)
    .setLabel("clear")
    .setColorLabel(colorscheme)
    .setPosition(190, 405)
    .setSize(50, 20)
    ;
  cp5.addButton("doSave")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("SAVE")
    .setColorLabel(colorscheme)
    .setPosition(190, 550)
    .setSize(50, 50)
    ;
    /*
  cp5.addToggle("drawGradient")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("gradient")
    .setColorLabel(colorscheme)
    .setPosition(10, 110)
    .setSize(20, 20)
    ; 
*/
  cp5.addToggle("bw")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("bw")
    .setColorLabel(colorscheme)
    .setPosition(80, 150)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addToggle("HSL")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("gradient")
    .setColorLabel(colorscheme)
    .setPosition(10, 110)
    .setSize(60, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addToggle("RGBmode")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("monochrome")
    .setColorLabel(colorscheme)
    .setPosition(80, 110)
    .setSize(20, 20)
    ;

  cp5.addToggle("randomColorMode")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(1)
    .setLabel("diff")
    .setColorLabel(colorscheme)
    .setPosition(10, 150)
    .setSize(20, 20)
    ;

  cp5.addToggle("strokeGradient")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(1)
    .setLabel("stroke")
    .setColorLabel(colorscheme)
    .setPosition(50, 150)
    .setSize(20, 20)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("scalini")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 200)
    .setSize(100, 20)
    .setRange(3, 50)
    .setValue(10)
    ;
  cp5 = new ControlP5(this);
  cp5.addSlider("estremi")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 230)
    .setSize(100, 20)
    .setRange(0, 360)
    .setValue(255)
    ;
  cp5.addSlider("inizio")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 260)
    .setSize(100, 20)
    .setRange(0, 360)
    .setValue(0)
    ;
  cp5.addSlider("bright")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 310)
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(50)
    ;
  cp5.addSlider("satura")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 340)
    .setSize(100, 20)
    .setRange(0, 100)
    .setValue(50)
    ;
  cp5.addSlider("adjustWidth")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 370)
    .setSize(100, 20)
    .setRange(50, 650)
    .setValue(650)
    .setLabel("Width")

    ;
  cp5.addSlider("adjustHeight")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setPosition(10, 400)
    .setSize(100, 20)
    .setRange(50, 700)
    .setValue(700)
    .setLabel("Heigth")

    ;
    cp5.addToggle("Info")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorValue(0)
    .setLabel("how to use")
    .setColorLabel(colorscheme)
    .setPosition(10, 700)
    .setSize(20, 20)
    ;
  //SPIRAL
  /*
   cp5.addButton("spirale")
   .setColorForeground(colorscheme)
   .setColorActive(colorscheme)
   .setColorValue(1)
   .setLabel("spirale")
   .setColorLabel(colorscheme)
   .setPosition(10, 455)
   .setSize(20, 20)
   ;*/
  cp5 = new ControlP5(this);
  cp5.addSlider("centerLimit")
    .setLabel("dimensione spirale")
    .setColorForeground(colorscheme)
    .setColorActive(colorscheme)
    .setColorLabel(colorscheme)
    .setColorValue(255)
    .setPosition(10, 485)
    .setSize(100, 20)
    .setRange(20, 500)
    .setValue(20)
    ;
}

void setupVoronoi() {

  smooth();
  // focus x positions around horizontal center (w/ 33% standard deviation)
  xpos=new BiasedFloatRange(0, width, width/2, 0.333f);
  // focus y positions around bottom (w/ 50% standard deviation)
  ypos=new BiasedFloatRange(0, height, height, 0.5f);
  // setup clipper with centered rectangle
  clip=new SutherlandHodgemanClipper(clipBounds);
  gfx = new ToxiclibsSupport(this);
}
