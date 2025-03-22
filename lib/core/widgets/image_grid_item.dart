import 'package:flutter/material.dart';
class ImageGridItem extends StatelessWidget {
  final dynamic item;
  final String Function(dynamic) getImageUrl;
  final String Function(dynamic) getTitle;
  final VoidCallback? Function(dynamic)? getOnTap;

  const ImageGridItem({
    super.key,
    required this.item,
    required this.getImageUrl,
    required this.getTitle,
    this.getOnTap,
  });

  @override
  Widget build(BuildContext context) {
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
              Image.asset(
                getImageUrl(item),
                fit: BoxFit.cover,
              ),
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
                child: Text(
                  getTitle(item),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}