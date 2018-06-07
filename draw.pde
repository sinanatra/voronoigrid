void drawVoronoi() {

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

    if (!HSL ) {
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


    float step = 1.0 / numeroScalini;
    for (float i = 1; i > 0; i -= step) {

      Polygon2D scalato = new Polygon2D();
      for (Vec2D point : poly.vertices) {
        scalato.add(new Vec2D((point.x - centro.x) * i + centro.x, (point.y - centro.y) * i + centro.y));
      }

      float colore = i * (end - start) + start;
      float brightness = i * (b - s) + s;
      float saturation = i * (c - s) + s;





      if (HSL==true ) {

        strokeWeight(0);    // use strokedim for same size, weight changes by the area
        colorMode(HSB, 360, 100, 100);
        fill(colore, brightness, saturation);
        doShowPoints = false;
      }

      if (randomColorMode && RGBmode == false) {
        colorMode(HSB, 860, 100, 100);
        strokeWeight(0);    // use strokedim for same size, weight changes by the area

        float randomColor = pow(cos(poly.getArea()), 2) * (end - start) + start;
        fill(randomColor, brightness, saturation);
      }
      if (randomColorMode && RGBmode == true) {
        colorMode(RGB, 255, 255, 255);
        strokeWeight(0);    // use strokedim for same size, weight changes by the area

        float randomColor = pow(cos(poly.getArea()), 2) * (end - start) + start;
        fill(randomColor, brightness, saturation);
      }      
      if (strokeGradient==true) {
        strokeWeight(1);    // use strokedim for same size, weight changes by the area
      }

      if (bw ) {
        colorMode(RGB, 255, 255, 255);
        noFill();
        strokeWeight(strokedim);    // use strokedim for same size, weight changes by the area
        strokeWeight(0);
        if (doShowLines) {
          strokeWeight(strokedim);    // use strokedim for same size, weight changes by the area
        }
      }
      if (HSL==true &&  RGBmode == true ) {
        colorMode(RGB, 255, 255, 255);
        fill(colore, colore, colore);
        doShowPoints = false;
        if (strokeGradient==true) {
          strokeWeight(1);    // use strokedim for same size, weight changes by the area
        }
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
    if (doShowDelaunay &&(!doClip || clip.getBounds().containsPoint(centro)) ) {

      stroke(colorscheme);
      strokeWeight(1);  


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

      if (randomEllipse) {
        noStroke();

        fill(colorscheme);
        ellipse(centro.x, centro.y, size, size);
        if (backgroundImage && randomEllipse) {

          fill(colors[0]);          // Set the SVG fill to white
          ellipse(centro.x, centro.y, size, size);
        }
      }  
      if (Rect) {
        rectMode(CENTER);  // Set rectMode to CENTER
        fill(colorscheme);
        noStroke();
        rect(centro.x, centro.y, ellipsesize, ellipsesize);
      } else {
        noStroke();
        fill(colorscheme);
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
    Rect clipBounds = new Rect(375, 10, adjustWidth, adjustHeight /*280*/);// rectangle that clips everything
    rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  }
  if (Info) {
    textFont(liguria);
    textSize(20); 

    fill(0, 0, 0);
    text("Gridsize :   change the distance", 400, 40);
    text("Strokedim :   change the size of stroke", 400, 60);
    text("Ellipsesize :   change the size of the ellipses", 400, 80);
    text("- - - - - - - - - - - - - - - - - - - - - ", 400, 100);
    text("Ellipse:   show / hide dots", 400, 120);
    text("Lines Visible :   show / hide lines", 400, 140);
    text("Organic :   draw without grid", 400, 160);
    text("Simmetric :   draw simmetric", 400, 180);
    text("RandomEllipse Size :   random ellipses", 400, 200);
    text("- - - - - - - - - - - - - - - - - - - - - ", 400, 220);
    text("Gradient :   create HSL gradient", 400, 240);
    text("Monocrome :   b/w gradient", 400, 260);
    text("Diff :   each polygon has a different hue", 400, 280);
    text("Stroke :   show lines in gradients", 400, 300);
    text("Bw :   just lines", 400, 320);
    text("Scalini :   number of steps in gradient", 400, 340);
    text("Estremi / Inizio :   HSL value", 400, 360);
    text("- - - - - - - - - - - - - - - - - - - - - ", 400, 380);
    text("Rect :   Rectangles instead of circles", 400, 400);
    text("Delaunay Triangulation :   Lines connecting dots", 400, 420);
    text("- - - - - - - - - - - - - - - - - - - - - ", 400, 440);
    text("Bright / Satura:   HSL Values", 400, 460);
    text("Width:   Resize Canvas in Width", 400, 480);
    text("Heigth:   Resize Canvas in Heigth", 400, 500);
    text("- - - - - - - - - - - - - - - - - - - - - ", 400, 520);
    text("Doclip:   Remove Boundings", 400, 540);

    text("Clear:   Empties Canvas", 400, 560);
    text("- - - - - - - - - - - - - - - - - - - - - ", 400, 580);

    text("Dimensione Spirale:   Spirals size", 400, 600);
    text("Save:   Saves a vector pdf", 400, 620);


    text("s :   Create Spirals", 400, 640);
    text("1 :   Horizontal Dots", 400, 660);
    text("2 :   Vertical Dots", 400, 680);
    text("! :   Add Random", 400, 700);
    text("Made with <3 by Giacomo Nanni", 600, 700);

    /*text("c: toggle clipping", 20, 620);
     text("h: toggle help display", 20, 640);
     text("space: save frame", 20, 660);*/
  }
  fill(255);
}

Vec2D getCenter(Polygon2D polygon) {
  for (Vec2D center : voronoi.getSites()) {
    if (polygon.containsPoint(center)) {
      return center;
    }
  }

  return polygon.getCentroid();
}
