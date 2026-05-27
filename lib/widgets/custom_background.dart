import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Color color;
  final double topPosition;
  final double leftPosition;
  final double rightPosition;
  final double bottomPosition;
  final double upperBlobSize;
  final double lowerBlobSize;

  const CustomBackground({
    super.key,
    required this.color,
    required this.topPosition,
    required this.leftPosition,
    required this.rightPosition,
    required this.bottomPosition,
    required this.upperBlobSize,
    required this.lowerBlobSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: topPosition,
          left: leftPosition,
          child: _blob(upperBlobSize, color.withOpacity(0.08)),
        ),
        Positioned(
          bottom: bottomPosition,
          right: rightPosition,
          child: _blob(lowerBlobSize, color.withOpacity(0.12)),
        ),
      ],
    );
  }

  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
