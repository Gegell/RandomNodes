class Helper {
  boolean tipsDisplayed;

  Helper() {
  }

  void displayTips() {
    noStroke();
    fill(0, 200);
    rect(width/2, height/2, width, height);
    fill(255);
    boolean isInsideBraces = false;
    String finalText = "";
    int line = 0;
    String type = "";
    for (int i = 0; i < Input.tips.length(); i++) {
      char ci = Input.tips.charAt(i);

      if (!isInsideBraces && ci == '[') {
        isInsideBraces = true;
        type = "";
      } else if (isInsideBraces) {
        while (isInsideBraces && ci != ']') {
          type += ci;
          if (type.length() > 10) {
            break;
          }
          i++;
          ci = Input.tips.charAt(i);
        }
        isInsideBraces = false;
        setTextType(type);
      } else if (i < Input.tips.length() - 1 && str(ci).contains("\n")) {
        line++;
        finalText = "";
      } else {
        text(Input.tips.charAt(i), textWidth(finalText) + 4, line * 12 + 2);
        finalText += Input.tips.charAt(i);
      }
    }
  }

  String getInfo() {
    String information = "";
    information += "Seed: " + hex(seed).substring(2) + "\n";
    information += "Con. Mode: " + Utils.getModeName(Utils.modeId) + "\n";
    information += "Edit mode: " + Utils.getEditModeName(editMode) + "\n";
    information += "Sort mode: " + Sorter.getSortModeName() + "\n"; 
    information += "Total connections: " + connections.connections.size() + "\n";
    information += "Avg. connections: " + averageNodeConnections() + "\n";
    information += "Max connections: " + maxNodes + "\n";
    information += "Nodes: " + numNodes + "\n";
    information += "\n";
    if (activeId >= 0) {
      information += "Id: " + activeId + "\n";
      information += "X: " + round(nodes[activeId].coord.x) + "\n";
      information += "Y: " + round(nodes[activeId].coord.y) + "\n";
      if (Utils.modeId == 0) {
        information += "Connected: " + nodes[activeId].connections.size() + "\n";
      } else if (Utils.modeId == 1) {
        information += "On Network: " + onNetwork + "\n";
      }
    }
    return information;
  }

  void setTextType(String type) {
    switch(type.toLowerCase()) {
    default:
    case "t":
      fill(255);
      return;
    case "k":
      fill(242, 85, 85);
      return;
    case "m":
      fill(85, 179, 242);
      return;
    case "h":
      fill(242, 242, 85);
    }
  }
}