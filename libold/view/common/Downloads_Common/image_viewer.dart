import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:petty_cash/resources/app_extension_context.dart';

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;
  final String documentType;
  final String documentTitle;

  const FullScreenImagePage({
    Key? key,
    required this.imageUrl,
    required this.documentType,
    required this.documentTitle,
  }) : super(key: key);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  double _rotation = 0;

  void _rotateImage() {
    setState(() {
      _rotation += 90; // Rotate 90 degrees
    });
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = context.resources.color.themeColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.documentTitle,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: _rotateImage, icon: const Icon(Icons.crop_rotate)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: widget.imageUrl,
                child: Transform.rotate(
                  angle: _rotation *
                      (3.1415927 / 180), // Convert degrees to radians
                  child: InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document Type: ${widget.documentType}',
                  style: TextStyle(color: themeColor, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Document Title: ${widget.documentTitle}',
                  style: TextStyle(color: themeColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
