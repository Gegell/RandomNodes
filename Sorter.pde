class Sorter {
  Sorter() {
  }

  String getSortModeName() {
    switch(sortMode) {
    case 0:
      return "N/A";
    case 1:
      return "Circle";
    case 2:
      return "Grid";
    default:
      return "Unknown";
    }
  }

  void sortNodes() {
    switch(sortMode) {
    default:
    case 0:
      randomField();
      return;
    case 1:
      toCircle();
      return;
    case 2:
      toGrid(16);
      return;
    }
  }
  
  void randomField() {
    for (Node node : nodes) {
      node.SetNewPosition();
    }
  }

  void toCircle() {
    float radius = (min(width, height) - 40)/2;
    float angle = TWO_PI / float(numNodes);
    for (int i = 0; i < numNodes; i++) {
      nodes[i].coord = new PVector(radius*sin(angle*i) + (width / 2), radius*cos(angle*i) + (height / 2));
    }
  }
  
  void toGrid(float tileDim) {
    int tabWdt = ceil(width / tileDim);
    int col = 0;
    for (Node node : nodes) {
      node.coord = new PVector((node.id % tabWdt) * tileDim + tileDim * 0.5, col * tileDim + tileDim * 0.5);
      if (node.id % tabWdt == tabWdt - 1) {
        col++;
      }
    }
  }
}