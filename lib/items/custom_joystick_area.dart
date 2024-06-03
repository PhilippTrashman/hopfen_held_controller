// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

import '../utils/bluetooth.dart';
import 'custom_joystick.dart';

const step = 10.0;
const ballSize = 20.0;

class CustomJoystickArea extends StatefulWidget {
  final InputHandler inputHandler; // Add InputHandler field

  const CustomJoystickArea({super.key, required this.inputHandler});

  @override
  State<CustomJoystickArea> createState() => _CustomJoystickAreaState();
}

class _CustomJoystickAreaState extends State<CustomJoystickArea> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: const Alignment(0, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Joystick(
              stick: const CustomJoystickStick(),
              base: const JoystickSquareBase(
                color: Color.fromARGB(255, 51, 107, 56),
              ),
              stickOffsetCalculator: const RectangleStickOffsetCalculator(),
              listener: (details) {
                widget.inputHandler.setJoystickData(details.x, details.y);
              },
            ),
          ),
        ),
      ),
    );
  }
}
