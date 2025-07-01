import 'package:flutter/material.dart';

Widget buildAnimatedGridItem(Map<String, dynamic> item, int index) {
  // Using Tween animations with delays for staggered effect
  const animationDuration = Duration(milliseconds: 300);
  final delayDuration = Duration(milliseconds: 100 * (index % 3));

  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: animationDuration + delayDuration,
    curve: Curves.easeOutQuad,
    builder: (context, value, child) {
      return Opacity(
        opacity: value,
        child: Transform.scale(
          scale: value,
          child: child,
        ),
      );
    },
    child: GestureDetector(
      onTap: item['route'],
      child: Card(
        color: const Color.fromARGB(255, 255, 209, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              item['imagePath'],
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
