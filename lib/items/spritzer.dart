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
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.local_fire_department,
                color: Color.fromARGB(255, 51, 107, 56),
              ),
              iconSize: screenHeight * 0.1,
            ),
          ),
        ),
      ),
      Spacer(),
    ],
  );
}
