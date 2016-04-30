class Connection {
  ArrayList<IntList> connections = new ArrayList<IntList>();
  
  Connection() {
    ArrayList<IntList> connections = new ArrayList<IntList>();
  }
  
  boolean addConnection(int[] newConnection) {
    if(hasConnection(newConnection)) {
      return false;
    }
    connections.add(Utils.toIntList(newConnection));
    return true;
  }
  
  boolean hasConnection(int[] testConnection) {
    for (IntList connection : connections) {
      if (connection.hasValue(testConnection[0]) && connection.hasValue(testConnection[1]) || testConnection[0] == testConnection[1]) {
        return true;
      }
    }
    return false;
  }
  
  void DrawConnections() {
    strokeWeight(1);
    stroke(0, 60);
    for (IntList nodeIds : connections) {
      Node node1 = nodes[nodeIds.get(0)];
      Node node2 = nodes[nodeIds.get(1)];
      line(node1.coord.x, node1.coord.y, node2.coord.x, node2.coord.y);
    }
  }
  
}