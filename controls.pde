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
    // simmetric shapes
    if (spirale) {
      theta=0; //reset theta
      for (int k=0; k<centerLimit; k++) {
        theta +=1;
        //One spiral in center with l1arge-ish shapes
        drawPoint(mouseX, mouseY, 3*theta/2, 3*theta/2);
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


    void keyPressed() {
      if (doSave) {
        doSave=true;
      }
      int limitone = 600; // variable to control the diameter of the spiral

      if (key == '1') {
        gridSize = int(random(0, 20));
        drawPoint( random(300, 900), random(300, 300));
        drawPoint( random(300, 900), random(300, 300));
        drawPoint( random(300, 900), random(300, 300));

        gridSize = int(random(20, 80));
        drawPoint( random(300, 900), random(550, 550));
        drawPoint( random(300, 900), random(550, 550));
        drawPoint( random(300, 900), random(550, 550));

        gridSize = int(random(20, 80));
        drawPoint( random(300, 900), random(100, 100));
        drawPoint( random(300, 900), random(100, 100));
        drawPoint( random(300, 900), random(100, 100));
      }

      if (key == '2') {
        drawPoint( random(300, 900), random(100, 100));
        drawPoint( random(300, 900), random(450, 550));
        drawPoint( random(300, 900), random(300, 100));
      }

      if (key == '3') {

        int k= 0;
        for (k=0; k<width; k+=gridSize) {
          drawPoint( k*3, 100);
          drawPoint( k*2, 150);
          drawPoint( k*3, 170);
          //
          drawPoint( k*3, 300);
          drawPoint( k*2, 350);
          drawPoint( k*3, 390);
          //
          drawPoint( k*3, 600);
          drawPoint( k*2, 650);
          drawPoint( k*3, 670);
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
