import 'package:arjun_guruji/features/Home/presentation/widgets/card_widget.dart';
import 'package:arjun_guruji/features/Home/models.dart';
import 'package:flutter/material.dart';

/// Generates the grid layout dynamically
Widget buildGrid(List<Items> items, double width, double height) {
  return Column(
    children: List.generate(
      (items.length / 2).ceil(), // Calculates number of rows needed
      (index) {
        final int firstIndex = index * 2;
        final int secondIndex = firstIndex + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardHome(
                  pagename: items[firstIndex], width: width, height: height),
              if (secondIndex < items.length)
                CardHome(
                    pagename: items[secondIndex], width: width, height: height),
            ],
          ),
        );
      },
    ),
  );
}
