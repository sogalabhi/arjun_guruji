import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  FullScreenImageViewerState createState() => FullScreenImageViewerState();
}

class FullScreenImageViewerState extends State<FullScreenImageViewer> {
  bool _showControls = true; // ✅ Controls Visibility Toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🖼 Full-Screen Image Viewer with Swipe & Zoom
          GestureDetector(
            onTap: () => setState(() =>
                _showControls = !_showControls), // 👆 Tap to Hide/Show Controls
            child: PhotoViewGallery.builder(
              itemCount: widget.imageUrls.length,
              pageController: PageController(initialPage: widget.initialIndex),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      CachedNetworkImageProvider(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.5,
                  heroAttributes: PhotoViewHeroAttributes(tag: "hero_$index"),
                );
              },
            ),
          ),

          /// 🔼 Close Button (Visible when _showControls is true)
          if (_showControls)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),

          /// 📥 Download & 📤 Share Floating Buttons
          if (_showControls)
            Positioned(
              bottom: 30,
              right: 20,
              child: Column(
                children: [
                  // Removed download button
                  // FloatingActionButton(
                  //   heroTag: "download_full",
                  //   onPressed: () =>
                  //       _saveImage(widget.imageUrls[widget.initialIndex]),
                  //   backgroundColor:
                  //       Colors.white.withAlpha((0.8 * 255).toInt()),
                  //   child: const Icon(Icons.download, color: Colors.black),
                  // ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Removed save image method
  // Future<void> _saveImage(String url) async {
  //   try {
  //     print("url: $url");
  //     // final response = await http.get(Uri.parse(url));
  //     // final Uint8List bytes = response.bodyBytes;
  //     // final result =
  //     // await ImageGallerySaver.saveImage(bytes, name: "downloaded_image");
  //     // if (result['isSuccess']) {
  //     //   Fluttertoast.showToast(msg: "✅ Image saved to gallery!");
  //     // } else {
  //     //   Fluttertoast.showToast(msg: "❌ Failed to save image!");
  //     // }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "⚠ Error: $e");
  //   }
  // }
}
