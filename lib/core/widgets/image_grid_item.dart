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
      imageWidget = _ErrorHandledImage(
        imageBytes: imageBytes,
        imageUrl: imageUrl,
      );
    } else {
      imageWidget = _ErrorHandledImage(
        imageUrl: imageUrl,
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
                    fontSize: 14,
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

class _ErrorHandledImage extends StatefulWidget {
  final Uint8List? imageBytes;
  final String imageUrl;
  const _ErrorHandledImage({this.imageBytes, required this.imageUrl});

  @override
  State<_ErrorHandledImage> createState() => _ErrorHandledImageState();
}

class _ErrorHandledImageState extends State<_ErrorHandledImage> {
  bool _memoryFailed = false;
  bool _networkFailed = false;
  int _retryCount = 0;


  @override
  Widget build(BuildContext context) {
    if (widget.imageBytes != null && widget.imageBytes!.isNotEmpty && !_memoryFailed) {
      return Image.memory(
        widget.imageBytes!,
        fit: BoxFit.cover,
        key: ValueKey('memory_${_retryCount}'),
        errorBuilder: (context, error, stackTrace) {
          setState(() => _memoryFailed = true);
          return _buildNetworkOrError();
        },
      );
    } else {
      return _buildNetworkOrError();
    }
  }

  Widget _buildNetworkOrError() {
    if (!_networkFailed) {
      return Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        key: ValueKey('network_${_retryCount}'),
        errorBuilder: (context, error, stackTrace) {
          setState(() => _networkFailed = true);
          return _buildErrorWidget();
        },
      );
    } else {
      return _buildErrorWidget();
    }
  }

  Widget _buildErrorWidget() {
    return Image.asset(
      'assets/17.jpg',
      fit: BoxFit.cover,
    );
  }
}