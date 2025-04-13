import 'dart:typed_data';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Gallery/presentation/pages/full_page_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class GalleryPage extends StatelessWidget {
  final List<String> imageUrls = List.generate(
    25,
    (index) =>
        "https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F${index + 1}.jpg?alt=media&token=70b2411b-5d8d-4677-9140-99875a18d217",
  );

  GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery"), centerTitle: true),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return _buildImageTile(context, imageUrls[index], index);
            },
          ),
        ),
      ),
    );
  }

  /// Image Tile with Shimmer Loading & Rounded Corners
  Widget _buildImageTile(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _openFullScreenViewer(context, index),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            /// Image with Caching & Shimmer Effect
            Hero(
              tag: "photo_$index",
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(height: 200, color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),

            /// Floating Action Buttons for Download & Share
            Positioned(
              bottom: 8,
              right: 8,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.amber[400],
                    heroTag: "download_$index",
                    onPressed: () => _saveImage(imageUrl),
                    mini: true,
                    child: const Icon(Icons.download, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    backgroundColor: Colors.amber[400],
                    heroTag: "share_$index",
                    onPressed: () => _shareImage(imageUrl),
                    mini: true,
                    child: const Icon(Icons.share, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Full-Screen Image Viewer with Zoom & Swipe
  void _openFullScreenViewer(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: imageUrls, // ✅ Pass the full image list
          initialIndex: index, // ✅ Open at tapped image index
        ),
      ),
    );
  }

  /// Save Image to Gallery
  Future<void> _saveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final Uint8List bytes = response.bodyBytes;

      // final result =
      //     await ImageGallerySaver.saveImage(bytes, name: "downloaded_image");

      // if (result['isSuccess']) {
      //   print("Image saved to gallery! ✅");
      // } else {
      //   print("Failed to save image ❌");
      // }
    } catch (e) {
      print("Error: $e ❌");
    }
  }

  /// Share Image via Apps
  Future<void> _shareImage(String url) async {
    try {
      final uri = Uri.parse(url);
      await Share.shareUri(uri);
    } catch (e) {
      print("Failed to share image ❌");
    }
  }
}
