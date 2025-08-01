import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const BuildCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 16.0),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
