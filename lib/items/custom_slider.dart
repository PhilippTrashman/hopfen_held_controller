import 'package:flutter/material.dart';
import 'dart:math';

import '../utils/bluetooth.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSlider();
}

class _CustomSlider extends State<CustomSlider> {
  double _value = 0.5;
  InputHandler inputHandler = InputHandler();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Transform.rotate(
                  angle: pi,
                  child: Slider(
                    activeColor: const Color.fromARGB(255, 51, 107, 56),
                    value: _value,
                    onChanged: (dynamic newValue) {
                      setState(() {
                        _value = newValue;
                        inputHandler.setLadderPosition(_value);
                      });
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
