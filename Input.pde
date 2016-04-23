class Input{
  StringDict configs;
  void applyChange(int typedKeyCode) {
    if (int(configs.get("key_respawn")) == typedKeyCode) {regenNodes();}
    else if(int(configs.get("key_toggle_information")) == typedKeyCode) {toggleInformation();}
    else if(int(configs.get("key_toggle_connections")) == typedKeyCode) {toggleConnections();}
    else if(int(configs.get("key_toggle_resize_nodes")) == typedKeyCode) {toggleResizeMode();}
    else if(int(configs.get("key_toggle_connection_draw_mode")) == typedKeyCode) {toggleConnectionDrawMode();}
    else if(int(configs.get("key_increase_max_connections")) == typedKeyCode) {increaseMaxConnections();}
    else if(int(configs.get("key_decrease_max_connections")) == typedKeyCode) {decreaseMaxConnections();}
    else if(int(configs.get("key_increase_node_count")) == typedKeyCode) {increaseNodeCount();}
    else if(int(configs.get("key_decrease_node_count")) == typedKeyCode) {decreaseNodeCount();}
    else if(int(configs.get("key_file_import")) == typedKeyCode) {importData();}
    else if(int(configs.get("key_file_export")) == typedKeyCode) {exportData();}
    else if(int(configs.get("key_reload_config")) == typedKeyCode) {loadConfig();}
  }
  
  void regenNodes() {
    println("Respawn");
    GenNewSeed();
    GenNewMap();
  }
  
  void toggleInformation() {
    showStats = !showStats;
    println("Show stats: " + showStats);
  }
  
  void toggleConnections() {
    showConnections = !showConnections;
    println("Show connections: " + showConnections);
  }
  
  void toggleResizeMode() {
    resizeNodesAfterConnections = !resizeNodesAfterConnections;
    println("Resize nodes after connections: " + resizeNodesAfterConnections);
    if (resizeNodesAfterConnections) {
      resizeNodes();
    } else {
      for (Node node : nodes) {node.nodeSize = 16;}
    }
  }
  
  void toggleConnectionDrawMode() {
    Utils.toggleModeId();
    markSelected();
    println("Set mode to " + Utils.getModeName(Utils.modeId));
  }
  
  void increaseMaxConnections() {
    maxNodes++;
    GenNewMap();
    println("Increased max connections to " + maxNodes);
  }
  
  void decreaseMaxConnections() {
    if (maxNodes > 0) {
      maxNodes--;
      GenNewMap();
      println("Decreased max connections to " + maxNodes);
    }
  }
  
  void increaseNodeCount() {
    numNodes += pow(10, (floor(Utils.log10(abs(numNodes)))));
    GenNewMap();
    println("Increased nodes to " + numNodes);
  }
  
  void decreaseNodeCount() {
    if (numNodes > 10) {
      numNodes -= pow(10, (floor(Utils.log10(abs(numNodes - 10)))));
      if (activeId > numNodes) {
        activeId = numNodes - 1;
      }
      GenNewMap();
      println("Decreased nodes to " + numNodes);
    }
  }
  
  void importData() {
    
  }
  
  void exportData() {
    Utils.saveToFile();
  }
  
  void loadConfig() {
    configs = new StringDict();
    boolean isInsideBraces = false;
    String lines[] = loadStrings("config.txt");
    println("Reloading config");
    for (String line : lines) {
      if (line.indexOf("{") == line.length() - 1) {isInsideBraces = true;}
      if (line.indexOf("}") >= 0) {isInsideBraces = false;}
      if (isInsideBraces && line.indexOf("=") >= 0) {
        String configName = trim(split(line,"=")[0]);
        String configValue = trim(split(line,"=")[1]);
        configValue = configValue.toUpperCase();
        print(configName + ": " + configValue);
        if (configValue.length() > 1 && configValue.charAt(0) == 'F') {
          configValue = str(111 + int(configValue.substring(1)));
          print(" > " + configValue);
        }
        if (int(configValue) == 0) {
          configValue = str(int(configValue.charAt(0)));
          print(" > " + configValue);
        }
        println();
        configs.set(configName, configValue);
      }
    }
  }
}