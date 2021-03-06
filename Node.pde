class Node { //<>//
  Node allNodes[];
  Connection allConnections;
  int maxNumConnections;
  int id;
  int type = 0;
  int nodeSize = 16;
  IntList connections = new IntList();
  PVector coord = new PVector();
  color generatedColor = color(random(230), random(230), random(230), random(150, 255));
  color nodeColor = generatedColor;

  Node(Node allNodes[], float maxConnections, int id, Connection connections) {
    this.allNodes = allNodes;
    if (!percentMaxNodeConnections) {
      this.maxNumConnections = int(random(maxConnections + 1));
    } else {
      this.maxNumConnections = int(map(maxConnections, 0.0, 100.0, 0, numNodes - 1));
    }
    this.id = id;
    this.allConnections = connections;
  }

  void Update() {
    DrawNode();
  }

  void DrawNode() {
    noStroke();
    fill(nodeColor);
    if (connections.size() == 1) {
      type = 1;
    } else {
      type = 0;
    }
    switch (type) {
    case 0:
    default:
      ellipse(coord.x, coord.y, nodeSize, nodeSize);
      break;
    case 1:
      rect(coord.x, coord.y, nodeSize, nodeSize, 2);
      break;
    }
  }

  void SetNewConnections() {
    int newConnections = 0;
    int maxConnection = allNodes.length;
    int timeout = 0;
    while (connections.size() < maxNumConnections && !(timeout > maxConnection + 100)) {
      int newConnection = int(random(maxConnection));
      if (newConnection != this.id) {
        if (AddNewConnection(newConnection)) {
          timeout = 0;
        }
      }
      timeout++;
    }
  }

  boolean AddNewConnection(int newConnection) {
    int[] newConnectionList = {this.id, newConnection};
    if (allConnections.addConnection(newConnectionList)) {
      connections.append(newConnection);
      allNodes[newConnection].connections.append(this.id);
      return true;
    }
    return false;
  }

  boolean RemoveConnection(int oldConnection) {
    int[] newConnectionList = {this.id, oldConnection};
    if (allConnections.removeConnection(newConnectionList)) {
      for (int c = 0; c < connections.size(); c++) {
        if (connections.get(c) == oldConnection) {
          connections.remove(c);
        }
      }
      IntList otherConnections = allNodes[oldConnection].connections;
      for (int c = 0; c < otherConnections.size(); c++) {
        if (otherConnections.get(c) == this.id) {
          otherConnections.remove(c);
        }
      }
      return true;
    }
    return false;
  }

  void SetNewPosition() {
    FindRandomPosition();
    int timeout = 0;
    if (numNodes >= 1000) {
      FindRandomPosition();
      return;
    }
    while (IsOverlapping(coord, nodeSize)) {
      FindRandomPosition();
      timeout++;
      if (timeout > 100) {
        break;
      }
    }
  }

  void FindRandomPosition() {
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