import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size; // Size for both width & height
  final String? errorImage;
  final String? userName;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.size = 50, // Default size (for width & height)
    this.errorImage,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, // Ensure a defined width
      height: size, // Ensure a defined height
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Makes sure it's circular
      ),
      child: ClipOval(
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 1,
                  ),
                ),
                errorWidget: (context, url, error) => _buildErrorWidget(),
              )
            : _buildErrorWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (userName != null && userName!.isNotEmpty) {
      // Extract first and last letter from the username
      String initials =
          "${userName![0]}${userName![userName!.length - 1]}".toUpperCase();
      return Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size / 2.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    } else {
      // Show error image if no username is provided
      return Image.asset(
        errorImage ?? 'assets/images/avtar.png', // Default error image
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
  }
}
