class Input {
  StringDict configs;
  String tips;
  String configPath = "data/config.txt";
  String tipPath = "data/tips.txt";
  
  Input() {
    loadTips();
    resetToConfig();
  }
  
  
  void applyChange() {
    if (isConfigKeyTyped("key_respawn")) {
      regenNodes();
    } else if (isConfigKeyTyped("key_toggle_information")) {
      toggleInformation();
    } else if (isConfigKeyTyped("key_toggle_connections")) {
      toggleConnections();
    } else if (isConfigKeyTyped("key_toggle_resize_nodes")) {
      toggleResizeMode();
    } else if (isConfigKeyTyped("key_toggle_edit_mode")) {
      toggleEditMode();
    } else if (isConfigKeyTyped("key_toggle_connection_draw_mode")) {
      toggleConnectionDrawMode();
    } else if (isConfigKeyTyped("key_toggle_resort")) {
      Sorter.sortNodes();
    } else if (isConfigKeyTyped("key_toggle_sort_mode")) {
      toggleSortMode();
    } else if (isConfigKeyTyped("key_increase_max_connections")) {
      increaseMaxConnections();
    } else if (isConfigKeyTyped("key_decrease_max_connections")) {
      decreaseMaxConnections();
    } else if (isConfigKeyTyped("key_increase_node_count")) {
      increaseNodeCount();
    } else if (isConfigKeyTyped("key_decrease_node_count")) {
      decreaseNodeCount();
    } else if (isConfigKeyTyped("key_file_import")) {
      importData();
    } else if (isConfigKeyTyped("key_file_export")) {
      exportData();
    } else if (isConfigKeyTyped("key_show_help")) {
      displayTips();
    } else if (isConfigKeyTyped("key_reload_config")) {
      loadConfig();
    } else if (isConfigKeyTyped("key_open_config_file")) {
      openConfigFile();
    } else if (isConfigKeyTyped("key_reset_to_config")) {
      resetToConfig();
    }
  }

  boolean isConfigKeyTyped(String configKey) {
    if (!configs.hasKey(configKey)) {
      return false;
    }
    return int(configs.get(configKey)) == keyCode;
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

  void toggleEditMode() {
    editMode++;
    if (editMode > 2) {
      editMode = 0;
    }
    markSelected();
  }

  void toggleSortMode() {
    sortMode++;
    if (sortMode > 2) {
      sortMode = 0;
    }
  }

  void toggleResizeMode() {
    resizeNodesAfterConnections = !resizeNodesAfterConnections;
    println("Resize nodes after connections: " + resizeNodesAfterConnections);
    if (resizeNodesAfterConnections) {
      resizeNodes();
    } else {
      for (Node node : nodes) {
        node.nodeSize = 16;
      }
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
    if (Utils.loadFromFile("")) {
      println("Sucessfully loaded the save file");
    } else {
      println("Could not load the file, check if the file path exists");
    }
  }

  void exportData() {
    Utils.saveToFile();
  }

  void openConfigFile() {
    if (Utils.fileExists(sketchPath(configPath))) {
      launch(sketchPath(configPath));
      println("Opened the config file");
    } else {
      println("Seriously ...? Why is the config.txt missing ?!?!??!?!");
    }
  }

  void resetToConfig() {
    if (!loadConfig()) return;
    println("Reset to config file");
    if (configs.hasKey("setup_show_stats")) {
      showStats = boolean(configs.get("setup_show_stats"));
    }
    if (configs.hasKey("setup_show_connections")) {
      showConnections = boolean(configs.get("setup_show_connections"));
    }
    if (configs.hasKey("setup_resize_nodes")) {
      resizeNodesAfterConnections = boolean(configs.get("setup_resize_nodes"));
    }
    if (configs.hasKey("setup_edit_mode")) {
      editMode = int(configs.get("setup_edit_mode"));
    }
    if (configs.hasKey("setup_number_nodes")) {
      numNodes = int(configs.get("setup_number_nodes"));
    }
    if (configs.hasKey("setup_max_connections")) {
      maxNodes = int(configs.get("setup_max_connections"));
    }
    GenNewMap();
  }
  
  void displayTips() {
    Helper.tipsDisplayed = !Helper.tipsDisplayed;
    Helper.displayTips();
  }

  boolean loadConfig() {
    configs = new StringDict();
    if (!Utils.fileExists(sketchPath(configPath))) {
      println("Seriously ...? Why is the config.txt missing ?!?!??!?!");
      return false;
    }
    boolean isInsideBraces = false;
    String lines[] = loadStrings(configPath);
    println("Loading config");
    for (String line : lines) {
      if (line.indexOf("{") == line.length() - 1) {
        isInsideBraces = true;
      }
      if (line.indexOf("}") >= 0) {
        isInsideBraces = false;
      }
      if (isInsideBraces && line.indexOf("=") >= 0) {
        String configName = trim(split(line, "=")[0]);
        String configValue = trim(split(line, "=")[1]);
        configValue = configValue.toUpperCase();
        print(configName + ": " + configValue);
        if (configName.contains("key")) {
          if (configValue.length() > 1 && configValue.charAt(0) == 'F') {
            configValue = str(111 + int(configValue.substring(1)));
          }
          if (int(configValue) == 0) {
            configValue = str(int(configValue.charAt(0)));
          }
          print(" > " + configValue);
        }
        println();
        configs.set(configName, configValue);
      }
    }
    return true;
  }

  void loadTips() {
    tips = "";
    if (!Utils.fileExists(sketchPath(tipPath))) {
      println("Lel, go download the tips.txt and/or put it inside the project folder. ;D");
      return;
    }
    String lines[] = loadStrings(tipPath);
    println("Loading tips");
    for (String line : lines) {
      tips += line;
      tips += "\n";
    }
    println(tips);
  }
}