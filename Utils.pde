class Utils {
  int modeId = 0;
  
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
}