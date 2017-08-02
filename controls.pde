void mouseDragged() {
  // organic shapes
  if (drawOrganic) {
    drawPoint(mouseX, mouseY, 0, 0, false);
  } else {
    drawPoint(mouseX, mouseY);
  }
}

void mousePressed() {
  mouseDragged();
  if (spirale) {
    theta=0; //reset theta 
    for (int k=0; k<centerLimit; k++) {     
      theta +=1;
      //One spiral in center with large-ish shapes
      drawPoint(mouseX, mouseY, 3*theta/2, 3*theta/2);
    }
  }
}

void keyPressed() {
  int limitone = 600; // variable to control the diameter of the spiral
  if (key == '5') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*1, k*1);
      drawPoint( k*2, k*2);
      drawPoint( k*2, k*3);
      drawPoint( k*4, k*4);
      drawPoint( k*5, k*5);
    }
  }

  if (key == '6') {

    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*2, height/8);
      drawPoint( k*2, height/7);
      drawPoint( k*2, height/6);
      drawPoint( k*2, height/5);
      drawPoint( k*2, height/4);
      drawPoint( height/8, k*2);
      drawPoint( height/7, k*2);
      drawPoint( height/6, k*2);
      drawPoint( height/5, k*2);
      drawPoint( height/4, k*2);
    }
  }

  if (key == '7') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( width/1, k*8);
      drawPoint( width/width, k*8);
    }
  }
  if (key == '8') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*6, height/1);
      drawPoint( k*6, height/height);
    }
  }
  if (key == '8') {
    int k= 0;
    for (k=0; k<limitone; k+=gridSize) {
      drawPoint( k*2, height/8);
      drawPoint( k*2, height/7);
      drawPoint( k*2, height/6);
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
    Vec2D paddedOrigin = clipBounds.getTopLeft().add(padding);
    point = point.sub(paddedOrigin);
    point = point.scale(1.0 / gridSize);
    point = new Vec2D(round(point.x), round(point.y));
    point = point.scale(gridSize);
    point = point.add(paddedOrigin);
  }

  Rect clipRect = new Rect(clipBounds.getTopLeft().add(padding), clipBounds.getBottomRight().sub(padding));
  if (doClip && !clipRect.containsPoint(point)) {
    return;
  }
  for (Vec2D existing : voronoi.getSites()) {
    if (existing.x == point.x && existing.y == point.y) {
      return;
    }
  }
  voronoi.addPoint(point);
}