class Node {
  Node allNodes[];
  Connection allConnections;
  int numConnected = 0;
  int maxNumConnections;
  int id;
  int nodeSize = 16;
  PVector coord = new PVector();
  color generatedColor = color(random(230), random(230), random(230), random(150, 255));
  color nodeColor = generatedColor;
  
  Node(Node allNodes[], float maxConnections, int id, Connection connections) {
    this.allNodes = allNodes;
    this.maxNumConnections = int(random(maxConnections + 1));
    this.id = id;
    this.allConnections = connections;
  }
  
  void Update() {
    DrawNode();
  }
  
  void DrawNode() {
    noStroke();
    fill(nodeColor);
    ellipse(coord.x, coord.y, nodeSize, nodeSize);
  }
  
  void SetNewConnections() {
    int newConnections = 0;
    int maxConnection = allNodes.length;
    int timeout = 0;
    while (newConnections < maxNumConnections && numConnected < maxNumConnections) {
      int newConnection = int(random(maxConnection));
      if (newConnection != this.id) {
        int[] newConnectionList = {this.id, newConnection}; //<>//
        if (allConnections.addConnection(newConnectionList)) {
          numConnected++;
          allNodes[newConnection].numConnected++;
          newConnections++;
          timeout = 0;
        }
      }
      timeout++;
      if (timeout > maxConnection + 100) {break;}
    } 
  }
  
  void SetNewPosition() {
    SetRandomPosition();
    int timeout = 0;
    while (IsOverlapping(coord, nodeSize)) {
      SetRandomPosition();
      timeout++;
      if (timeout > 100) {
        break;
      }
    }
  }
  
  void SetRandomPosition() {
    this.coord.x = random(nodeSize / 2, width - nodeSize / 2);
    this.coord.y = random(nodeSize / 2, height - nodeSize / 2);
  }
  
  boolean IsOverlapping(PVector coord, int diameter) {
    boolean overlapps = false;
    for (Node node : allNodes) {
      if (dist(node.coord.x, node.coord.y, coord.x, coord.y) < (diameter+node.nodeSize)/2 && node.id != id) {
        overlapps = true;
        break;
      }
    }
    return overlapps;
  }
  
  boolean IsInArray(int search, int[] toSearch) {
    boolean inArray = false;
    for (int pointer = 0; pointer < toSearch.length; pointer++) {
      if (toSearch[pointer] == search) {
        inArray = true;
        break;
      }
    }
    return inArray;
  }
}