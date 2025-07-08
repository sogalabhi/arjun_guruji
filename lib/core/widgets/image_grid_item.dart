import 'package:flutter/material.dart';
import 'dart:typed_data';
class ImageGridItem extends StatelessWidget {
  final dynamic item;
  final String Function(dynamic) getImageUrl;
  final Uint8List? Function(dynamic)? getImageBytes;
  final String Function(dynamic) getTitle;
  final VoidCallback? Function(dynamic)? getOnTap;

  const ImageGridItem({
    super.key,
    required this.item,
    required this.getImageUrl,
    required this.getTitle,
    this.getOnTap,
    this.getImageBytes,
  });

  @override
  Widget build(BuildContext context) {
    final imageBytes = getImageBytes?.call(item);
    final imageUrl = getImageUrl(item);
    Widget imageWidget;
    // Try to use cached imageBytes, fallback to network if fails
    if (imageBytes != null && imageBytes.isNotEmpty) {
      imageWidget = Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // If cached image fails, fallback to network
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
              );
            },
          );
        },
      );
    } else {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
          );
        },
      );
    }
    return InkWell(
      onTap: getOnTap?.call(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageWidget,
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withAlpha((0.6 * 255).toInt()),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  getTitle(item),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}