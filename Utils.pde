class Utils {
  int modeId = 0;
  boolean canOverride = true;
  Node[] allNodes;
  
  Utils(Node[] allNodes) {
    this.allNodes = allNodes;
  }
  
  String getModeName(int modeId) {
    switch(modeId) {
      case 0:
        return "Direct Connections";
      case 1:
        return "Network";
      default:
        return "Unknown";
    }
  }
  
  void toggleModeId() {
    switch(modeId) {
      case 0:
        modeId = 1;
        break;
      case 1:
        modeId = 0;
        break;
    }
  }
  
  String saveToFile() {
    StringList output = new StringList();
    
    for (Node node : allNodes) {
      String nodeOutput = "N";
      nodeOutput += node.id + " ";
      nodeOutput += node.coord.x + ",";
      nodeOutput += node.coord.y + " ";
      nodeOutput += node.generatedColor + " ";
      nodeOutput += "[";
      int connectionCounter = 0;
      for (int connection : node.connections) {
        nodeOutput += connection;
        connectionCounter++;
        if (connectionCounter < node.connections.size()) {
          nodeOutput += ",";
        }
      }
      nodeOutput += "]";
      output.append(nodeOutput);
    }
    String fileName = getFileName();
    saveStrings(fileName, output.array());
    return fileName;
  }
  
  String getFileName() {
    String fileName = "saves/save_" + getTimeStamp();
    if (fileExists(fileName + ".txt") && !canOverride) {
      int numFileCopys = 1;
      while (fileExists(fileName + "(" + numFileCopys + ")" + ".txt")) {
        numFileCopys++;
      }
      fileName += "(" + numFileCopys + ")";
    }
    fileName += ".txt";
    return fileName;
  }
  
  String getTimeStamp() {
    String timeStamp = "";
    if (hour() < 10) {timeStamp += "0";}
    timeStamp += hour();
    if (minute() < 10) {timeStamp += "0";}
    timeStamp += minute() + "_";
    if (day() < 10) {timeStamp += "0";}
    timeStamp += day();
    if (month() < 10) {timeStamp += "0";}
    timeStamp += month();
    timeStamp += str(year()).substring(2);
    return timeStamp;
  }
  
  boolean fileExists(String filename) {
    if (loadStrings(filename) == null) {
      println("Ignore that error");
      return false;
    }
    return true;
  }
}