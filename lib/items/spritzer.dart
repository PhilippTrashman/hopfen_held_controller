import 'dart:async';
import 'package:flutter/material.dart';

import '../utils/bluetooth.dart';
import 'custom_slider.dart';

Widget spritzerExpanded(double screenHeight) {
  InputHandler inputHandler = InputHandler();
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Spacer(),
      const Expanded(flex: 2, child: CustomSlider()),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    inputHandler.setLightState(1);
                    Timer(const Duration(seconds: 1), () {
                      inputHandler.setLightState(0);
                    });
                  },
                  icon: const Icon(
                    Icons.local_fire_department,
                    color: Color.fromARGB(255, 51, 107, 56),
                  ),
                  iconSize: screenHeight * 0.1,
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    debugPrint(inputHandler.getAutopilotState().toString());
                    if (inputHandler.getAutopilotState() == 1) {
                      inputHandler.setAutopilotState(0);
                    } else {
                      inputHandler.setAutopilotState(1);
                    }
                  },
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: Color.fromARGB(255, 51, 107, 56),
                  ),
                  iconSize: screenHeight * 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
      Spacer(),
    ],
  );
}
