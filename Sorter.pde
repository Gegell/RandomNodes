class Sorter {
  Sorter() {
  }

  String getSortModeName() {
    switch(sortMode) {
    case 0:
      return "Circle";
    default:
      return "Unknown";
    }
  }

  void sortNodes() {
    switch(sortMode) {
    default:
    case 0:
      toCircle();
      return;
    }
  }

  void toCircle() {
    float radius = (min(width, height) - 40)/2;
    float angle = TWO_PI / float(numNodes);
    for (int i = 0; i < numNodes; i++) {
      nodes[i].coord = new PVector(radius*sin(angle*i) + (width / 2), radius*cos(angle*i) + (height / 2));
    }
  }
}