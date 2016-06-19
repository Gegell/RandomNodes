int numNodes = 10;
int maxNodes = 1;
int seed;
int activeId = -1;
int editMode = 1;
boolean showStats = true;
boolean showConnections = true;
boolean resizeNodesAfterConnections = false;
Node[] nodes;
Connection connections;
Utils Utils = new Utils();
Input Input = new Input();

void setup() {
  Input.resetToConfig();
  GenNewSeed();
  surface.setResizable(true);
  surface.setTitle("Random Nodes");
  size(480, 320);
  rectMode(CENTER);
  GenNewMap();
  sortNodes();
}

void draw() {
  background(255);
  for (Node node : nodes) {
    if (node != null) {
      node.Update();
    }
  }
  if (showConnections) {
    connections.DrawConnections();
  }
  if (showStats) {
    DisplayStats();
  }
}

void mousePressed() {
  int prevId = activeId;
  activateClickedNode();
  if (editMode == 2 && activeId >= 0 && prevId >= 0 && prevId != activeId) {
    int testConnection[] = {activeId, prevId};
    if (connections.hasConnection(testConnection)) {
      nodes[activeId].RemoveConnection(prevId);
    } else {
      nodes[activeId].AddNewConnection(prevId);
    }
    if (resizeNodesAfterConnections) resizeNodes();
    activeId = prevId;
    markSelected();
  }
}

void mouseDragged() {
  if (editMode == 1 && activeId >= 0) {
    nodes[activeId].coord = new PVector(mouseX, mouseY);
  }
}

void keyPressed() {
  //println("'" + key + "': " + keyCode);
  Input.applyChange();
}

boolean activateClickedNode() {
  int prevActiveId = activeId;
  activeId = getIdAt(mouseX, mouseY);
  if (activeId != prevActiveId) {
    markSelected();
    if (activeId >= 0) {
      println("Activated id " + activeId);
    } else {
      println("Deactivated all nodes");
    }
    return true;
  }
  return false;
}

int getIdAt(float x, float y) {
  int activeId = -1;
  for (int i = nodes.length - 1; i >= 0; i--) {
    if (dist(nodes[i].coord.x, nodes[i].coord.y, x, y) < nodes[i].nodeSize/2) {
      activeId = nodes[i].id;
      break;
    }
  }
  return activeId;
}

void GenNewMap() {
  nodes = new Node[numNodes];
  connections = new Connection();
  for (int i = 0; i < numNodes; i++) {
    nodes[i] = new Node(nodes, maxNodes, i, connections);
  }
  for (Node node : nodes) {
    node.SetNewPosition();
    node.SetNewConnections();
  }
  if (resizeNodesAfterConnections) {
    resizeNodes();
  }
  markSelected();
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
  String information = "";
  information += "Seed: " + hex(seed).substring(2) + "\n";
  information += "Mode: " + Utils.getModeName(Utils.modeId) + "\n";
  information += "Edit mode: " + Utils.getEditModeName(editMode) + "\n";
  information += "Total connections: " + connections.connections.size() + "\n";
  information += "Avg. connections: " + averageNodeConnections() + "\n";
  information += "Max connections: " + maxNodes + "\n";
  information += "Nodes: " + numNodes + "\n";
  information += "\n";
  if (activeId >= 0) {
    information += "Id: " + activeId + "\n";
    information += "X: " + round(nodes[activeId].coord.x) + "\n";
    information += "Y: " + round(nodes[activeId].coord.y) + "\n";
    information += "Connected: " + nodes[activeId].connections.size() + "\n";
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
    nodes[activeId].nodeColor = getActiveColor();
  } else {
    for (Node node : nodes) {
      node.nodeColor = node.generatedColor;
    }
  }
}

color getActiveColor() {
  switch (editMode) {
  default:
    return color(242, 85, 179);
  case 1:
    return color(242, 179, 85);
  case 2:
    return color(85, 179, 242);
  }
}

void resizeNodes() {
  float maxNodeConnections = nodes[0].connections.size();
  float minNodeConnections = maxNodeConnections;
  for (Node node : nodes) {
    maxNodeConnections = max(maxNodeConnections, node.connections.size());
    minNodeConnections = min(minNodeConnections, node.connections.size());
  }
  if (maxNodeConnections - minNodeConnections != 0) {
    for (Node node : nodes) {
      node.nodeSize = int(8 + (24 * ((node.connections.size() - minNodeConnections) / (maxNodeConnections - minNodeConnections))));
    }
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

void sortNodes() {
  float radius = (min(width, height) - 40)/2;
  float angle = TWO_PI / float(numNodes);
  for (int i = 0; i < numNodes; i++) {
    nodes[i].coord = new PVector(radius*sin(angle*i) + (width / 2),radius*cos(angle*i) + (height / 2));
  }
}