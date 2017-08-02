void setupControls() {
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
}

void setupVoronoi() {
  smooth();
  // focus x positions around horizontal center (w/ 33% standard deviation)
  xpos=new BiasedFloatRange(0, width, width/2, 0.333f);
  // focus y positions around bottom (w/ 50% standard deviation)
  ypos=new BiasedFloatRange(0, height, height, 0.5f);
  // setup clipper with centered rectangle
  //Rect clipBounds = new Rect(width*0.355, height*0.125, width*0.55, height*0.85);

  clip=new SutherlandHodgemanClipper(clipBounds);
  gfx = new ToxiclibsSupport(this);
}