class InputHandler {
  static final InputHandler _instance = InputHandler._internal();

  factory InputHandler() {
    return _instance;
  }

  InputHandler._internal();

  double? xValue = 0.0;
  double? yValue = 0.0;
  double? ladderPosition = 0.5;
  int? lightState = 0;
  int? autopilotState = 0;

  reset() {
    xValue = 0.0;
    yValue = 0.0;
    ladderPosition = 0.5;
    lightState = 0;
    autopilotState = 0;
  }

  setJoystickData(double inputXValue, double inputYValue) {
    xValue = inputXValue;
    yValue = inputYValue;
  }

  setLadderPosition(double position) {
    ladderPosition = position;
  }

  setLightState(int state) {
    lightState = state;
  }

  setAutopilotState(int state) {
    autopilotState = state;
  }

  List getJoystickData() {
    return [xValue, yValue];
  }

  double getLadderPosition() {
    return ladderPosition!;
  }

  int getLightState() {
    return lightState!;
  }

  int getAutopilotState() {
    return autopilotState!;
  }
}
