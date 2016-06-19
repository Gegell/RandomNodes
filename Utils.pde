class Utils {
  int modeId = 0;
  boolean canOverride = true;
  String saveFileName = "save"; //If not specified it will use the date and time
  Node[] allNodes;

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

  String getEditModeName(int modeId) {
    switch(modeId) {
    case 0:
      return "Selection";
    case 1:
      return "Moving";
    case 2:
      return "Connection";
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

  void saveToFile() {
    allNodes = nodes;
    Table table = new Table();
    table.addColumn("id");
    table.addColumn("x");
    table.addColumn("y");
    table.addColumn("color");
    table.addColumn("connections");
    for (Node node : allNodes) {
      TableRow newRow = table.addRow();
      newRow.setInt("id", node.id);
      newRow.setFloat("x", node.coord.x);
      newRow.setFloat("y", node.coord.y);
      newRow.setString("color", hex(node.generatedColor));
      newRow.setString("connections", "[" + join(nf(node.connections.array(), 0), ", ") + "]");
    }
    String fileName = getFileName();
    saveTable(table, fileName, "csv");
    println("Saved to \"" + fileName + "\"");
  }

  boolean loadFromFile(String fileName) {
    if (fileName == "") {
      fileName = "saves/" + saveFileName + ".txt";
    }
    if (!fileExists(fileName)) {
      return false;
    }
    connections = new Connection();
    Table saveFileData = loadTable(fileName, "header,csv");
    nodes = new Node[saveFileData.getRowCount()];
    for (TableRow row : saveFileData.rows()) {
      Node newNode = new Node(nodes, 0, row.getInt("id"), connections);
      newNode.coord = new PVector(row.getFloat("x"), row.getFloat("y"));
      newNode.generatedColor = color(unhex(row.getString("color")));
      nodes[row.getInt("id")] = newNode;
    }
    for (TableRow row : saveFileData.rows()) {
      for (int connection : int(splitTokens(row.getString("connections"), "[] ,"))) {
        nodes[row.getInt("id")].AddNewConnection(connection);
      }
    }
    if (resizeNodesAfterConnections) {
      resizeNodes();
    }
    markSelected();
    return true;
  }

  String getFileName() {
    String fileName;
    if (saveFileName == "") {
      fileName = "saves/save_" + getTimeStamp();
    } else {
      fileName = "saves/" + saveFileName;
    }
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
    if (hour() < 10) {
      timeStamp += "0";
    }
    timeStamp += hour();
    if (minute() < 10) {
      timeStamp += "0";
    }
    timeStamp += minute() + "_";
    if (day() < 10) {
      timeStamp += "0";
    }
    timeStamp += day();
    if (month() < 10) {
      timeStamp += "0";
    }
    timeStamp += month();
    timeStamp += str(year()).substring(2);
    return timeStamp;
  }

  boolean fileExists(String fileName) {
    File file = new File(sketchPath(fileName));
    return(file.exists());
  }

  float log10(int x) {
    return (log(x) / log(10));
  }

  IntList toIntList(int[] intArray) {
    IntList newIntList = new IntList();
    for (int i : intArray) {
      newIntList.append(i);
    }
    return newIntList;
  }
}