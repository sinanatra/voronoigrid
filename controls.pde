void mouseDragged() {
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

void mousePressed() {
  boolean stickToGrid = !drawOrganic;
  if (drawSimmetric) {
    // symmetric shape
    drawSymmetricPoint(mouseX, mouseY, 0, 0, stickToGrid);
  } else {
    // free form
    drawPoint(mouseX, mouseY, 0, 0, stickToGrid);
  }
}

void keyPressed() {


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
      drawPoint( k, 100);
      drawPoint( k, 200);
      //
      drawPoint( k, 350);
      drawPoint(k, 450);
      //
      drawPoint( k, 650);
    }
  }

  if (key == '2') {
    int k= 0;
    for (k=0; k<height; k+=gridSize) {
      //  drawPoint((clipBounds.x+clipBounds.x/2.2), k);
      drawPoint((clipBounds.x+clipBounds.x/4.5), k);
      drawPoint((clipBounds.x+clipBounds.x/1.2), k);
    }
  }
  if (key == '3') {
    //  rect(clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);

    int k= 0;
    for (k=0; k<width; k+=gridSize) {
      drawPoint(k, clipBounds.height/2);
    }
  }
  if (key == '4') {
    int k= 0;
    for (k=0; k<height; k+=gridSize) {
      drawPoint((clipBounds.x+clipBounds.x/2), k);
    }
  }
  if (key == '5') {
    int k= 0;
    for (k=0; k<width; k+=gridSize) {
      drawPoint(k, clipBounds.height);
      drawPoint(k, clipBounds.height/9);
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

void drawPoint(float orgX, float orgY) {
  drawPoint(orgX, orgY, 0, 0);
}
void drawPoint(float orgX, float orgY, float theta, float diameter) {
  drawPoint(orgX, orgY, theta, diameter, true);
}
void drawPoint(float orgX, float orgY, float theta, float diameter, boolean stickToGrid) { // generates and adds circular points
  Vec2D padding = new Vec2D(gridSize / 2, gridSize / 2);
  Vec2D point = new Vec2D(diameter, 0);
  point = point.getRotated(theta);
  point = point.add(new Vec2D(orgX, orgY));
  if (stickToGrid) {
    Vec2D centroid = clipBounds.getCentroid();
    point = point.sub(centroid);
    point = point.scale(1.0 / gridSize);
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

void drawSymmetricPoint(float orgX, float orgY) {
  drawSymmetricPoint(orgX, orgY, 0, 0, true);
}
void drawSymmetricPoint(float orgX, float orgY, float theta, float diameter, boolean stickToGrid) {

  drawPoint(orgX, orgY, theta, diameter, stickToGrid);
  float axis = clipBounds.x + clipBounds.width / 2;
  drawPoint(2 * axis - orgX, orgY, PI - theta, diameter, stickToGrid);
}