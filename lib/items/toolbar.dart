import 'package:flutter/material.dart';

import '../utils/bluetooth.dart';

Container toolbarContainer(double screenHeight) {
  InputHandler inputHandler = InputHandler();

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10), // Optional: Set border radius
    ),
  );
}
