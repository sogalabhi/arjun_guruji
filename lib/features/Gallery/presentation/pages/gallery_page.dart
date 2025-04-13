import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Gallery/data/datasource/gallery_remote_ds.dart';
import 'package:arjun_guruji/features/Gallery/presentation/pages/full_page_viewer_page.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  Future<List<String>> _generateImageUrls(
      GalleryRemoteDataSource remoteDataSource) async {
    final galleryData = await remoteDataSource.fetchGalleryData();
    final count = galleryData['count'] as int? ?? 0;
    final baseUrl = galleryData['baseUrl'] as String? ?? '';
    final afterUrl = galleryData['afterUrl'] as String? ?? '';

    return List.generate(
      count,
      (index) => "$baseUrl${index + 1}$afterUrl",
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrlsFuture = _generateImageUrls(
      GalleryRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<String>>(
            future: imageUrlsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MasonryGridView.builder(
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  ),
                  itemCount: 8, // Placeholder shimmer items
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.white),
                ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  "No images available",
                  style: TextStyle(color: Colors.white),
                ));
              }

              final imageUrls = snapshot.data!;
              return _buildGalleryGrid(context, imageUrls);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(BuildContext context, List<String> imageUrls) {
    return MasonryGridView.builder(
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return _buildImageTile(context, imageUrls[index], index, imageUrls);
      },
    );
  }

  Widget _buildImageTile(
    BuildContext context,
    String imageUrl,
    int index,
    List<String> allImages,
  ) {
    return GestureDetector(
      onTap: () => _openFullScreenViewer(context, index, allImages),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
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
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, size: 60),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Column(
                children: [
                  _floatingIcon(
                    icon: Icons.download,
                    onTap: () => _saveImage(imageUrl),
                    tag: "download_$index",
                  ),
                  const SizedBox(height: 8),
                  _floatingIcon(
                    icon: Icons.share,
                    onTap: () => _shareImage(imageUrl),
                    tag: "share_$index",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingIcon({
    required IconData icon,
    required VoidCallback onTap,
    required String tag,
  }) {
    return FloatingActionButton(
      backgroundColor: Colors.amber[400],
      heroTag: tag,
      onPressed: onTap,
      mini: true,
      child: Icon(icon, color: Colors.black),
    );
  }

  void _openFullScreenViewer(
      BuildContext context, int index, List<String> imageUrls) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  Future<void> _saveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final Uint8List bytes = response.bodyBytes;

      // Implement actual saving using image_gallery_saver or gallery_saver
      // await ImageGallerySaver.saveImage(bytes, name: "downloaded_image");

      print("Image ready for saving ✅");
    } catch (e) {
      print("Error saving image ❌: $e");
    }
  }

  Future<void> _shareImage(String url) async {
    try {
      await Share.shareUri(Uri.parse(url));
    } catch (e) {
      print("Failed to share image ❌: $e");
    }
  }
}
