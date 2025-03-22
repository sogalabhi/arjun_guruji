import 'package:arjun_guruji/core/widgets/image_grid_item.dart';
import 'package:flutter/material.dart';

class ImageGridView extends StatelessWidget {
  final List<dynamic> items;
  final String Function(dynamic) getImageUrl;
  final String Function(dynamic) getTitle;
  final VoidCallback? Function(dynamic)? getOnTap;

  const ImageGridView({
    super.key,
    required this.items,
    required this.getImageUrl,
    required this.getTitle,
    this.getOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ImageGridItem(
          item: item,
          getImageUrl: getImageUrl,
          getTitle: getTitle,
          getOnTap: getOnTap,
        );
      },
    );
  }
}
