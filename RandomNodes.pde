int numNodes = 10;
int maxNodes = 1;
int seed;
int activeId = -1;
Node[] nodes;
Connection connections;
Utils Utils;
boolean showStats = true;
boolean showConnections = true;
boolean resizeNodesAfterConnections = false;
color bufferColor;

void setup() {
  GenNewSeed();
  surface.setResizable(true);
  surface.setTitle("Random Nodes");
  size(480,320);
  GenNewMap();
  bufferColor = nodes[0].nodeColor;
}

void draw() {
  background(255);
  for (Node node : nodes) {
    node.Update();
  }
  if (showConnections) {connections.DrawConnections();}
  if (showStats) {DisplayStats();}

}

void mouseClicked() {
  int prevActiveId = activeId;
  activeId = -1;
  for (Node node : nodes) {
    if (dist(node.coord.x, node.coord.y, mouseX, mouseY) < node.nodeSize/2) {
      activeId = node.id;
      break;
    }
  }
  if (activeId != prevActiveId) {
    markSelected();
    if (activeId >= 0) {
      println("Activated id " + activeId);
    } else {println("Deactivated all nodes");}
  }
}

void keyPressed() {
  //println(keyCode);
  if (key != CODED) {
  switch(key) {
    case ' ': //Space - Respawn
      println("Respawn");
      GenNewSeed();
      GenNewMap();
      break;
    case 'i': //i - toggle information
      showStats = !showStats;
      println("Show stats: " + showStats);
      break;
    case 'c': //c - show/hide the connections
      showConnections = !showConnections;
      println("Show connections: " + showConnections);
      break;
    case 'r': //r - node size after connection count
      resizeNodesAfterConnections = !resizeNodesAfterConnections;
      println("Resize nodes after connections: " + resizeNodesAfterConnections);
      if (resizeNodesAfterConnections) {
        resizeNodes();
      } else {
        for (Node node : nodes) {node.nodeSize = 16;}
      }
      break;
    case 'h': //h - increase max connections
      maxNodes++;
      GenNewMap();
      println("Increased max connections to " + maxNodes);
      break;
    case 'b': //b - decrease max connections
      if (maxNodes > 0) {
        maxNodes--;
        GenNewMap();
        println("Decreased max connections to " + maxNodes);
      }
      break;
    case 'j': //j - increase node count
      numNodes += 10;
      GenNewMap();
      println("Increased nodes to " + numNodes);
      break;
    case 'n': //n - decrease node count
      if (numNodes > 10) {
        numNodes -= 10;
        if (activeId > numNodes) {
          activeId = numNodes - 1;
        }
        GenNewMap();
        println("Decreased nodes to " + numNodes);
      }
      break;
    case 'm': //m - mode toggle
      Utils.toggleModeId();
      markSelected();
      println("Set mode to " + Utils.getModeName(Utils.modeId));
      break;
    case 'f': //f - for file import
      break;
    case 's': //s - for file export
      Utils.saveToFile();
      break;
    /*case 69: //e
      editMode = !editMode;
      println("Toggled edit to " + editMode);*/
    }
  }
}

void GenNewMap() {
  nodes = new Node[numNodes];
  connections = new Connection(nodes);
  for (int i = 0; i < numNodes; i++) {
    nodes[i] = new Node(nodes, maxNodes, i, connections);
  }
  for (Node node : nodes) {
    node.SetNewPosition();
    node.SetNewConnections();
  }
  if (resizeNodesAfterConnections) {resizeNodes();}
  markSelected();
  Utils = new Utils(nodes);
}

void GenNewSeed() {
  seed = int(random(0x1000000));
  randomSeed(seed);
}

void DisplayStats() {
  int textSize = 12;
  fill(0);
  textSize(textSize);
  textLeading(textSize);
  String information = "Seed: " + hex(seed) + "\n";
  information += "Mode: " + Utils.getModeName(Utils.modeId) + "\n";
  information += "Total connections: " + connections.connections.size() + "\n";
  information += "Avg. connections: " + averageNodeConnections() + "\n";
  information += "Max connections: " + maxNodes + "\n";
  information += "Nodes: " + numNodes + "\n";
  if (activeId >= 0) {
    information += "\n";
    information += "Id: " + activeId + "\n";
    information += "X: " + round(nodes[activeId].coord.x) + "\n";
    information += "Y: " + round(nodes[activeId].coord.y) + "\n";
    information += "Connected: " + nodes[activeId].numConnected + "\n";
  }
  text(information, 4, textSize);
}

void setAllNodeColors(color setTo) {
  for (Node node : nodes) {
    node.nodeColor = setTo;
  }
}

void markSelected() {
  if (activeId >= 0) {
    IntList nodeConnections = getConnections(activeId);
    setAllNodeColors(color(100));
    for (int id : nodeConnections) {
      if (id != activeId) {
        nodes[id].nodeColor = color(18, 231, 145);
      }
    }
    nodes[activeId].nodeColor = color(242,179,85);
  } else {
    for (Node node : nodes) {node.nodeColor = node.generatedColor;}
  }
}

void resizeNodes() {
  float maxNodeConnections = 1;
  for (Node node : nodes) {maxNodeConnections = max(maxNodeConnections, node.numConnected);}
  for (Node node : nodes) {
    node.nodeSize = int(8 + 32 * (node.numConnected / maxNodeConnections));
  }
}

float averageNodeConnections() {
  float avg = float(connections.connections.size() * 2) / nodes.length;
  return avg;
}

IntList getConnections(int startId) {
  IntList foundConnections = new IntList();
  for (int connectionId : nodes[startId].connections) {
    if (!foundConnections.hasValue(connectionId)) {
      foundConnections.append(connectionId);
    }
  }
  if (Utils.modeId == 1) {
    for (int subNodeId : foundConnections) {
      for (int subNodeConnectionId : nodes[subNodeId].connections) {
        if (!foundConnections.hasValue(subNodeConnectionId)) {
          foundConnections.append(subNodeConnectionId);
        }
      }
    }
  }
  return foundConnections;
}