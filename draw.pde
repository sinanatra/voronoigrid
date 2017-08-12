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

    if (!drawGradient) {
      strokeWeight(0);
      numeroScalini = 1;
      start = 255;
      end = 255;
      b = 100;
      s = 100;
      c=100;
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
      if (HSL==false && bw== false) {
        colorMode(RGB, 255, 255, 255);
        fill(colore, colore, colore);
        noStroke();
        noFill();
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
    // draw  points added to voronoi
    gfx.polygon2D(fullPoly);
    fill(PointsColor);
    if (doShowPoints && (!doClip || clip.getBounds().containsPoint(centro))) {
      strokeWeight(0);
      // float size = pow(cos(poly.getArea()), 2) * (40 - 5) + 5;

      float size = pow(cos(poly.getCircumference()), 2) * (20 - 5) + 5;
      if (randomEllipse) {
        strokeWeight(ellipsesize);
        ellipse(centro.x, centro.y, size, size);
      } else if (Rect) {
        rectMode(CENTER);  // Set rectMode to CENTER
        fill(255, 255, 0);
        noStroke();
        rect(centro.x, centro.y, ellipsesize, ellipsesize);
      } else {
        noStroke();
        ellipse(centro.x, centro.y, ellipsesize, ellipsesize);
      }
    }
  }  

  if (clearCanvas) {
    voronoi = new Voronoi();
    clearCanvas = false;

    rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
  }
}

Vec2D getCenter(Polygon2D polygon) {
  for (Vec2D center : voronoi.getSites()) {
    if (polygon.containsPoint(center)) {
      return center;
    }
  }

  return polygon.getCentroid();
}