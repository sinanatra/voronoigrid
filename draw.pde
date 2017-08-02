void drawVoronoi() {
  //rect(0, 0, width, height);
  stroke(lines);
  // strokeWeight(strokedim); 
  // stroke(0);
  noFill();
  // draw all voronoi polygons, clip if needed

  for (Polygon2D poly : voronoi.getRegions()) {

    Vec2D centro = getCenter(poly);

    //int PointsColor = color(random(0, 20), random(0, 255), random(0, 255)); // color circle
    // int lines = color(random(0, 20), random(0, 255), random(0, 255)); // color circle

    float weight = pow(cos(poly.getArea()), 2) * (4 - 1) + 1;
    // use strokedim for same size, weight changes by the area
    strokeWeight(strokedim);
    strokeCap(SQUARE);
    //strokeWeight(weight);
    float start = pow(cos(poly.getArea()), 2) * (255 - 63) + 63;
    float end = pow(sin(poly.getArea()), 2) * (255 - 63) + 63;
    start = inizio;
    end = estremi;
    int numeroScalini = scalini;

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
      if (doClip) {
        scalato = clip.clipPolygon(scalato);
      }
      gfx.polygon2D(scalato);
      strokeWeight(0);
    }

    if (doShowPoints && (!doClip || clip.getBounds().containsPoint(centro))) {
      fill(PointsColor);
      strokeWeight(0);
      ellipse(centro.x, centro.y, ellipsesize, ellipsesize);
    }
    if (doSave) {
      endRaw();
      exit();
    }
  }

  if (clearCanvas) {
    voronoi = new Voronoi();
    clearCanvas = false;
  }   

  // draw original points added to voronoi
}

Vec2D getCenter(Polygon2D polygon) {
  for (Vec2D center : voronoi.getSites()) {
    if (polygon.containsPoint(center)) {
      return center;
    }
  }

  return polygon.getCentroid();
}