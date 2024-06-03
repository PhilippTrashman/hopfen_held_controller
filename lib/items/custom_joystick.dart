import 'package:flutter/material.dart';

class CustomJoystickStick extends StatelessWidget {
  final double size;

  const CustomJoystickStick({
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(92, 71, 26, 0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(80, 80, 80, 0.8),
            Color.fromRGBO(60, 60, 60, 0.8),
          ],
        ),
      ),
    );
  }
}